#! /usr/bin/env python3

import base64
import json
import requests
import csv
import re
import itertools
import os
from requests.adapters import HTTPAdapter
from urllib3.util import Retry
from datetime import datetime
#from apiCalls.retryRequests import requestsRetrySession

# Constants:
#
#

# The following 4 values can be obtained from Contrast TeamServer via User Menu->User Settings->Profile (Your Keys):
USERNAME	= "" 	# first.last@domain
ORG_ID 		= ""
API_KEY 	= ""	# For SuperAdmin, switch to SuperAdmin and get API_Key for SuperAdmin Organization
SERVICE_KEY 	= ""

# Custom Settings:
SERVER_HOST 	= "https://apptwo.contrastsecurity.com" 	# Example: https://apptwo.contrastsecurity.com"
SERVER_PATH 	= "Contrast/api/ng"
FILE_PATH = "/tmp"
FILE_NAME = "contrast_security.yaml"
LANGUAGE = "JAVA"

# Do not change:
AUTHORIZATION = base64.b64encode((USERNAME + ':' + SERVICE_KEY).encode('utf-8'))
HEADER 		= {"API-Key": API_KEY, "Authorization": AUTHORIZATION}
TRANSLATE_DATE	= ['last_startup', 'last_activity', 'defense_last_update', 'last_startup', 'last_activity', 'assess_last_update', 'defense_last_update', 'discovered', 'last_seen', 'first_time_seen', 'last_time_seen', 'last_vuln_time_seen']


# Helper Functions:
#
#

# Retries the API call if it fails
def requestsRetrySession(retries = 3, backoff_factor = 0.3, status_forcelist=(500, 502, 504), session=None,):
	
	session = session or requests.Session()

	retry = Retry(
		total=retries,
		read=retries,
		connect=retries,
		backoff_factor=backoff_factor,
		status_forcelist=status_forcelist,
	)

	adapter = HTTPAdapter(max_retries=retry)
	session.mount('http://', adapter)
	session.mount('https://', adapter)
	
	return session

# Check that the Org Admin also has Admin app access
def checkAdminAppAccess(admin, orgId):
    
	hasAdminAppAccess = None
	user = admin["uid"]
	url = SERVER_HOST + "/" + SERVER_PATH + "/superadmin/ac/groups/" + orgId + "/" + user + "/groups?base=true&expand=organizations,skip_links"
        
	try:
		response = requestsRetrySession().get(url, headers=HEADER, stream=True, ) #proxies=cf.PROXIES)
	except requests.exceptions.HTTPError as errh:
		print('The script fell over accessing the org credentials: ' + url)
		print ("Http Error:", errh)
	except requests.exceptions.ConnectionError as errc:
		print('The script fell over accessing the org credentials: ' + url)
		print ("Error Connecting:", errc)
	except requests.exceptions.Timeout as errt:
		print('The script fell over accessing the org credentials: ' + url)
		print ("Timeout Error:", errt)
	except requests.exceptions.RequestException as err:
		print('The script fell over accessing the org credentials: ' + url)
		print ("OOPS! Something went wrong:", err)

	jsonreader = json.loads(response.text)
	groups = jsonreader['groups']

	for item in range(len(groups)):
		if "admin" in groups[item]['name']:
			hasAdminAppAccess = True
			break
		else: 
			hasAdminAppAccess = False

	return hasAdminAppAccess


# API call to get the API credentials for the specified Org Admin
def getOrgCredentials(user, orgId):

	url = SERVER_HOST + "/" + SERVER_PATH + "/superadmin/users/" + user + "/" + orgId + "/keys"

	try:
		response = requestsRetrySession().get(url, headers=HEADER, stream=True, ) #proxies=cf.PROXIES)
	except requests.exceptions.HTTPError as errh:
		print('The script fell over accessing the org credentials: ' + url)
		print ("Http Error:", errh)
	except requests.exceptions.ConnectionError as errc:
		print('The script fell over accessing the org credentials: ' + url)
		print ("Error Connecting:", errc)
	except requests.exceptions.Timeout as errt:
		print('The script fell over accessing the org credentials: ' + url)
		print ("Timeout Error:", errt)
	except requests.exceptions.RequestException as err:
		print('The script fell over accessing the org credentials: ' + url)
		print ("OOPS! Something went wrong:", err)

	jsonreader = json.loads(response.text)

	# Handle auth failures
	if 'messages' in jsonreader:
		if jsonreader['messages'] == ['Authorization failure']:
			print('Auth failure getting Org level credentials for: ' + orgId)
			return None, None
		else:
			return jsonreader['service_key'], jsonreader['api_key']
			#orgCreds[orgId] = [jsonreader['api_key'],auth]
	

# Main:
#
#

print("\nExporting all {} {} files for {} to {}/Contrast/[ORG_ID]/[USER_ID]\n".format(LANGUAGE, FILE_NAME, SERVER_HOST, FILE_PATH))

# Step 1: Get Orgs
LIMIT = 25

offset = 0
total_count = 1
orgs = []

while offset < total_count:
	url = SERVER_HOST + "/" + SERVER_PATH + "/superadmin/organizations" + "?expand=skip_links&offset=" + str(offset) + "&limit=" +str(LIMIT)

	try:
		response = requestsRetrySession().get(url, headers=HEADER, stream=True, ) #, proxies=cf.PROXIES)
	except requests.exceptions.HTTPError as errh:
		print('The script fell over accessing the orgs: ' + url)
		print ("Http Error:", errh)
	except requests.exceptions.ConnectionError as errc:
		print('The script fell over accessing the orgs: ' + url)
		print ("Error Connecting:", errc)
	except requests.exceptions.Timeout as errt:
		print('The script fell over accessing the orgs: ' + url)
		print ("Timeout Error:", errt)
	except requests.exceptions.RequestException as err:
		print('The script fell over accessing the orgs: ' + url)
		print ("OOPS! Something went wrong:", err)

	jsonreader = json.loads(response.text)

	total_count = jsonreader["count"]
	progress_step = total_count // (LIMIT * 2)
	retrieved_items = len(jsonreader["organizations"])

	# populate the org list
	for item in range(retrieved_items):
		if not jsonreader["organizations"][item]["locked"]:
			orgs.append(jsonreader["organizations"][item]) 

	if total_count > 0:
		progress = int( ((offset+1) / total_count) * 100 )
	else: 
		progress = 100
	offset = offset + LIMIT
print("Found {} unlocked Org's{}".format(len(orgs), " " * 30))

# Step 2: Get Active Admins
activeAdmins = []

# Loop through our list of unlocked Orgs
for item in range(len(orgs)):
	orgName = orgs[item]['name']
	orgId = orgs[item]['organization_uuid']
        
	print("Checking active admin for: {}...{}".format(orgName, " " * 30), end='\n')
	# Check whether the Org has any licenses allocated
	if orgs[item]['total_assessment_licenses'] > 0 or orgs[item]['total_protection_licenses'] > 0:
		admins = orgs[item]['admins']
		# Loop through the admins to find an active one, then store it and break
		for admin in range(len(admins)):
			if admins[admin]['can_impersonate']:
				if checkAdminAppAccess(admins[admin],orgId):
					activeAdmins.append([orgs[item]['organization_uuid'],admins[admin]['uid']])
					break

print("Found {} active admins{}".format(len(activeAdmins), " " * 30))


# Step 3: Populate Org Credentials
orgCredsList = []
# Trying to get same length of progress bar as previous try based on step size and current array length:
#progress_step = len(activeAdmins) // progress_step
counter = 0

for item in range(len(activeAdmins)):
	user_name = activeAdmins[item][1]
	org_id = activeAdmins[item][0]
	#orgCredsList.append(getOrgCredentials(activeAdmins[item][1],activeAdmins[item][0]))
	service_key, api_key = getOrgCredentials(user_name, org_id)

	if service_key:
		auth = base64.b64encode((user_name + ':' + service_key).encode('utf-8'))

		progress = int( ((item+1) / len(activeAdmins)) * 100 )
		#print("Reading Org Credentials: [{}{}] {}%".format('=' * (progress // progress_step), '-' * ( (100 // progress_step) - (progress // progress_step) ), progress), end='\r')
		print("Generating yaml for {}... [{}%]{}".format(user_name, progress, " " * 30), end='\r')

		path = FILE_PATH + "/contrast/" + org_id + "/" + user_name
		print("New Path is {}".format(path))
        
		os_error = False
		if not os.path.isdir(path):
			try:
				os.makedirs(path)
			except OSError: 
				print("Failed generating yaml for {}{}".format(user_name, " " * 30))
				os_error = True

		if not os_error:
			url 	= SERVER_HOST + "/" + SERVER_PATH + "/" + org_id + "/agents/external/default/" + LANGUAGE
			header 	= {'API-Key': api_key, 'Authorization': auth, 'content-type':'application/json','Accept':'text/yaml'}
			data = {'metadata':'[]'}
	
			with open(path + "/" + FILE_NAME, "wb") as out_file:
				try:
					response = requestsRetrySession().get(url, headers = header, data = data, stream = True, ) #, proxies=cf.PROXIES)
					out_file.write(response.content)
					counter += 1
				except requests.exceptions.HTTPError as errh:
					print('The script fell over accessing the orgs: ' + url)
					print ("Http Error:", errh)
				except requests.exceptions.ConnectionError as errc:
					print('The script fell over accessing the orgs: ' + url)
					print ("Error Connecting:", errc)
				except requests.exceptions.Timeout as errt:
					print('The script fell over accessing the orgs: ' + url)
					print ("Timeout Error:", errt)
				except requests.exceptions.RequestException as err:
					print('The script fell over accessing the orgs: ' + url)
					print ("OOPS! Something went wrong:", err)

print("Created {} files [{}] in {}{}\n".format(counter, FILE_NAME, FILE_PATH + "/[USER_ID]", " " * 30))
