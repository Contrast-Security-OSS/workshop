+++
title = "Module 5: Using the TeamServer REST API"
chapter = true
description = "The Contrast Security Workshop"
outputs = ["Reveal"]
layout = "bundle"
draft = false

[logo]
src = "../images/contrast.png"
alt = "Contrast Security"
[reveal_hugo.templates.note]
background = "#32a852"
transition = "zoom"

[reveal_hugo.templates.info]
background = "#0011dd"
transition = "convex"

[reveal_hugo.templates.tip]
background = "#faa332"
transition = "zoom"

[reveal_hugo.templates.warning]
background = "#fa220a"
transition = "zoom"
+++

{{% note %}}
Instructors: you'll need to configure a few things for this workshop available in the GitHub repository.  Each section has a README to guide you.

- Use apps/eval-provisioning/create-orgs.sh to setup your student users with accounts on the Eval TeamServer.
- Use apps/setup.sh to setup and run vulnerable applications in containers on a Kubernetes cluster.  We're configured to use AKS.
- Provision a running VM for each user from a workstation image sourced on Azure.
{{% /note %}}
# Module 5: Using the TeamServer REST API

Jump to:
- [Module Introduction](#/module-introduction)
- [The WebGoat application](#/the-webgoat-application)
- [The Contrast API](#/the-contrast-api)
- [LAB: You API credentials](#/your-api-credentials)
- [Next Steps](#/next-steps)

---
{{< slide id="module-introduction" >}}
## Module Introduction

In this section we'll guide you through a sequence of steps to exercise the Contrast Security REST APIs with pre-configured applications.

This module is useful for members that wish to gain better understanding of how to automate with the Contrast API.

---
### Objectives

- Gain familiarity with the Contrast Security API

---
{{< slide template="info" >}}
### Time and Prerequisites
This module should take about 30 minutes to complete.

Be sure to have completed the [prerequisites](../#/setup-and-prerequisites)  

---

### Sample application - WebGoat

We'll start by deploying a vulnerable Java application named WebGoat.  This is a Java open-sourced example designed to helped explain common vulnerabilities as identified by the OWASP Foundation. 

At Contrast Security, we place emphasis on _instrumenting_ software to help teams get better results faster as part of their DevOps pipelines.  In this module, you will see the benefits of seeing these results faster.  

---
### Building and instrumenting code

The application for this module is available at https://github.com/Contrast-Security-OSS/WebGoat_BBP_FORK but we've already built and instrumented the code to get us a working environment faster.

In later modules, we'll walk you through the process of instrumenting an application.

---
### Deploying your application
This workshop is designed to have you deploy an application so you can see its data added as part of an onboarding lifecycle.

Your instructor already deployed applications configured with your TeamServer credentials.  You will receive the connection details for your applications as a URLs for each vulnerable application.

---
{{< slide id="the-contrast-api" >}}
## The Contrast API

The TeamServer User Interface is designed to help users find and see information quickly and easily.  

TeamServer utilizes the API on the backend, and Contrast Security has made this API available to external users.

Contrast Security also provides programmatic access for teams that wish to integrate with their existing systems.

You can also reference the Contrast Security [API documentation](https://api.contrastsecurity.com).
 
---
### API Overview

We will show you how to programmatically access information via API and compare the results with the User Interface to show consistency.

To programmatically use the API, you will need specific details to make them work.

Real world teams will see familiar patterns and techniques in the Contrast API if they have used others.  Teams have taken great liberty using their favorite programming or scripting languages to automate against our API in their preferred toolchain.

---
{{% note %}}
The dashboard is a landing page for all Contrast Security users - developers, operations, security, and administrators.  The different dashboard pages provide an overview for your team to quickly assess the status of the application security.  
{{% /note %}}

### Log on to TeamServer
Log onto the Contrast Security UI at https://eval.contrastsecurity.com with the username and password your instructor supplied to you.

Next, we'll find your API details.

{{< figure src="../images/04-dashboard.png#center" height="400px" text-align="center">}}
[See the full-sized picture](../images/04-dashboard.png)

--- 
{{< slide id="your-api-credentials" >}}
### API credentials

In TeamServer, Click on your name in the upper-right hand corner and then select "Organization Settings" to find your API details.

{{< figure src="16-user-details.png">}}

Next, click on the API heading on the left to get those details
{{< figure src="16-user-details-api.png"   height="300px"
caption="[See the full-sized picture](16-user-details-api.png)" >}}

Let's look at the content of that page to find the first piece of information.

---
### REST API Details

The REST API page has the details you need to complete programmatic access to the server.  On this page, we'll focus on two pieces of information:
- `{org_uuid}`
- `{api_key}`

{{< figure src="16-user-details-api-rest.png" height="300px" 
caption="[See the full-sized picture](16-user-details-api-rest.png)" >}}

NOTE: If you examined your `contrast_security.yaml` file, you will notice some of the same fields.

---
### Your Organization ID

On Teamserver, users belong to one or more *organizations* as a grouping mechanism.   All members of this workshop belong to the same organization, so it is easier for members to see each other's results.

Companies use organizations to group by team, product, location, or any other logical structure suitable for their business.  

---
### Your API Key

API access does not use your username and password.

Instead, API access utilizes secrets.  One of them is the API key.

On TeamServer, the API key is a secret required to access the API via command line or REST calls.  The examples of this workshop use your API key.

---
### Generate Sample API Request

The next piece of information is your Authorization Key.  Click on the "Generate Sample API Request" button on the Rest API Details page. 

The Authorization is the string of characters following the `-H 'Authorization:` text.  This Authorization value is necessary for REST API transactions.  You'll use this information in CLI, or your preferred programming environment.  

We'll refer to this value as `{authorization_key}`

From a programming perspective, this information is sent along with your *Headers* when performing a REST call. 

{{< figure src="16-user-details-api-auth.png" >}}

---
### Sample API Request
The sample API rquest is a multi-line command suitable for Linux distributions, but not convenient for Windows environments.  Since this workshop uses Windows machines, we'll need to reformat the commands.  Fortunately, we also provide helper-scripts to make the process easier.

{{< figure src="16-your-account-profile.png" height="400px"
caption="[See the full-sized picture](16-your-account-profile.png)"
>}}

---
### Your Application ID

One more piece of information is the unique ID for your application.

On Teamserver, navigate to your application and examine the URL which is structured similarly to the following:
 
```text
https://eval.contrastsecurity.com/Contrast/static/ng/index.html#/c992a0ef-e965-4f92-a410-e09256a78758/applications/2ac60539-9d58-4365-a006-dc0fc51efc7e
```

The two embedded IDs are your organization ID and then your Application ID.  The ID after  `applications/` is your application ID and has the following value for the example above.

- `2ac60539-9d58-4365-a006-dc0fc51efc7e`

Make note of the Application ID because we'll need for other examples.

---
### Source code: scripts

We've published files to GitHub for you to access.

Check out the code to get helper scripts for this module.  We'll assume you are always working from the same base directory as shown by the `%HOMEPATH%` reference below.
 
From your workstation, open a command prompt and run the following command:

```
cd %HOMEPATH%
git clone https://github.com/Contrast-Security-OSS/workshop
```

The command-line commands you will run will be from the checked out folder, named `workshop.`
  
The next slide contains instructions to get started.

---
### Setup files

Execute the following commands in *Powershell* to generate client scripts to access the API:
```powershell
cd %HOMEPATH%\workshop\scripts\module5
.\setup.ps1
```

You will be prompted for these values:
- `{org_uuid}`
- `{api_key}`
- `{authorization_key}`
- `{app_id}`

The outputs are scripts with the content you need.  You can always re-run `setup.bat` to reset your scripts.

---
### Sample API Request - Output

The first script we have helps you get the list of all applications in your organization.

Run with the following command to observe the results via the API:

```
cd %HOMEPATH%\workshop\scripts\module5
get-application-details.bat
```

The results are similar to the contents below.  This is the first example of the type and variety of information your team can get via the API.

```json
{
  "success" : true,
  "messages" : [ "Applications loaded successfully" ],
  "applications" : [ {
    "name" : "workshopmm5-spring-petclinic",
    "path" : "/",
    "language" : "Java",
    "created" : 1596637021000,
    "status" : "online",
    "importance" : 2,
    "archived" : false,
    "assess" : true,
    "assessPending" : false,
    "master" : false,
    "notes" : "",
    "defend" : false,
    "roles" : [ "ROLE_EDIT", "ROLE_RULES_ADMIN", "ROLE_ADMIN", "ROLE_VIEW" ],
    "tags" : [ "spring", "workshop" ],
    "techs" : [ ],
    "policies" : [ ],
    "missingRequiredFields" : null,
    "links" : [ {
      "rel" : "self",
      "href" : "/ng/f785be93-d99b-4140-859b-48b42b0e39f9/applications/a093bbce-4060-4d88-b9fb-444267966285",
      "hreflang" : null,
      "media" : null,
      "title" : null,
      "type" : null,
      "deprecation" : null,
      "method" : "GET"
    }, {
      "rel" : "report",
      "href" : "/ng/f785be93-d99b-4140-859b-48b42b0e39f9/applications/a093bbce-4060-4d88-b9fb-444267966285/report",
      "hreflang" : null,
      "media" : null,
      "title" : null,
      "type" : null,
      "deprecation" : null,
      "method" : "GET"
    }, {
      "rel" : "scores",
      "href" : "/ng/f785be93-d99b-4140-859b-48b42b0e39f9/applications/a093bbce-4060-4d88-b9fb-444267966285/scores",
      "hreflang" : null,
      "media" : null,
      "title" : null,
      "type" : null,
      "deprecation" : null,
      "method" : "GET"
    }, {
      "rel" : "platform-score",
      "href" : "/ng/f785be93-d99b-4140-859b-48b42b0e39f9/applications/a093bbce-4060-4d88-b9fb-444267966285/scores/platform",
      "hreflang" : null,
      "media" : null,
      "title" : null,
      "type" : null,
      "deprecation" : null,
      "method" : "GET"
    }, {
      "rel" : "security-score",
      "href" : "/ng/f785be93-d99b-4140-859b-48b42b0e39f9/applications/a093bbce-4060-4d88-b9fb-444267966285/scores/security",
      "hreflang" : null,
      "media" : null,
      "title" : null,
      "type" : null,
      "deprecation" : null,
      "method" : "GET"
    }, {
```

---
{{< slide id="libraries" >}}
### Libraries - TeamServer

Next, navigate to your WebGoat application and click into the Libraries subpage to see a page similar to what is shown below.

You can acceess this page by navigating to your application page, and then clicking on the "Libraries" subheading.
  
When you see the list of several dozen libraries, you may be reminded how teams use similar information in their automation tasks.  

{{< figure src="09-webgoat-libraries.png" height="400px"
caption="[See the full-sized picture](09-webgoat-libraries.png)"
>}}

---
### Third-party Software

In a previous module, we covered how teams use Library details because they want to know the following:
- What third-party software are we including?
- What third-party software are we using?
- Are we in compliance with those third-party software components?

Your team will want to automate processes to find details _interesting_ to them.  The next example shows the same result via API call.

---
### Library via API call
{{% note %}}
As with other aspects of Contrast Security, the API lets you programmatically access details.
{{% /note %}}

The REST call has a structure similair to previous examples:

```text
curl -X GET https://ce.contrastsecurity.com/Contrast/api/ng/{org_uuid}/libraries -H "Authorization:{authorization_key}" -H "API-Key:{api_key}"
```

On your workstation, we've made it easy for you to run the command with a script:

```
cd %HOMEPATH%\workshop\scripts\module5
get-libraries.bat
```

A subset of the output follows.  Teams already used to using JSON bodies will quickly note they can leverage the well-named fields to make better automation decisions.  For example, `classes_used` and `classes_count`.

```json
{
  "success" : true,
  "messages" : [ "Libraries loaded successfully" ],
  "libraries" : [ {
    "hash" : "0142ce64dcd709a4b5f6e7d71305a31d3893d077",
    "file_name" : "jackson-core-2.6.3.jar",
    "app_language" : "Java",
    "custom" : false,
    "grade" : "A",
    "score" : 100,
    "agePenalty" : 0.0,
    "versionPenalty" : 0.0,
    "version" : "2.6.3",
    "group" : "com.fasterxml.jackson.core",
    "file_version" : "2.6.3",
    "latest_version" : "2.10.0.pr1",
    "release_date" : 1444669679000,
    "latest_release_date" : 1563505582000,
    "classes_used" : 8,
    "class_count" : 93,
    "loc" : 38934,
    "loc_shorthand" : "39K",
    "total_vulnerabilities" : 0,
    "months_outdated" : 9,
    "versions_behind" : 47,
    "high_vulnerabilities" : 0,
    "tags" : null,
    "restricted" : false,
    "invalid_version" : false,
    "bugtracker_tickets" : [ ],
    "licenses" : [ ],
    "ossEnabled" : false
  }],
  "count" : null,
  "averageScoreLetter" : "B",
  "averageScore" : 85,
  "averageMonths" : null,
  "quickFilters" : [ ]
```

---
### The Vulnerabilities Page
Let's revisit your application's Vulnerabilities page.  On that page you will find a list of vulnerabilities organized by Severity and other fields.

We will get the same information via API.
 
{{< figure src="09-webgoat-vulnerabilities.png" height="500px"
caption="[See the full-sized picture](09-webgoat-vulnerabilities.png)"
>}}

---
### List vulnerabilities

Similar to the Libraries request, we have a sample API call to get a summary of found vulnerabilities where details specific to your application and server are represented by the values in braces `{}`.

```text
curl -X GET https://eval.contrastsecurity.com/Contrast/api/ng/{org_uuid}/traces/{app_id}/quick -H "Authorization:{authorization_key}" -H "API-Key:{api_key}"
curl -X GET https://eval.contrastsecurity.com/Contrast/api/ng/{org_uuid}/traces/{app_id}/ids -H "Authorization:{authorization_key}" -H "API-Key:{api_key}"
```

On your workstation, we've made it easy for you to run the command with a script where we filled in the missing details.

```
cd %HOMEPATH%\workshop\scripts\module5
get-vulnerabilities.bat
```

The output is presented on the next page.

---
### CLI output of Vulnerabilties

{{% note %}}
In this screen, we highlight the virtues of being a DevOps-friendly solution because of our API access at the CLI, or your other tooling.
When your teams integrate Contrast Security into your toolchain using the same techniques as other solutions, you amplify your capabilities by being able to automate decisions and process with the RIGHT information.
{{% /note %}}

Below, we see two results.  The first JSON body is the summary of the vulnerabilities, indicating there are 24 of them.  The second JSON body retrieves the UUIDs of the individual vulnerabilities.  This is an example of how your team might create a workflow of API calls to get lists of information, and operate on them to fit your automation model.

```json
$ curl -X GET https://eval.contrastsecurity.com/Contrast/api/ng/.../quick ...
{
  "success" : true,
  "messages" : [ "Vulnerability quick filters loaded successfully" ],
  "filters" : [ {
    "name" : "All",
    "count" : 24,
    "filterType" : "ALL"
  }, {
    "name" : "Open",
    "count" : 24,
    "filterType" : "OPEN"
  }, {
    "name" : "High Confidence",
    "count" : 3,
    "filterType" : "HIGH_CONFIDENCE"
  } ]
}
$ curl -X GET https://eval.contrastsecurity.com/Contrast/api/ng/.../traces/.../ids 
{
  "success" : true,
  "messages" : [ "Vulnerabilities UUIDs loaded successfully" ],
  "traces" : [ "J6CH-5G5N-TQ71-9YG7", "WNBK-4R83-K1RS-PCQR", "RPCD-2I7D-QPHS-EDYJ", "WYFM-99KV-GR92-93RS", "3MPJ-7B5T-AJR5-A7PQ", "SBSK-0HIO-PQ8R-XGH2", "G55I-JQ8I-T2J8-0CMR", "LPTU-VY7O-3AN7-1PQP", "VEYK-WQ6O-WUSF-0G58", "KWH0-TDLU-IKOJ-OQYC", "WG02-QSBC-FNQL-TP7Q", "FJVS-KJSM-PFHI-IKUQ", "4CUY-OYM5-8T41-VJOG", "SK9A-OVK3-OIIA-T1NN", "KX4L-QMIM-9I1Y-ECF4", "I3M0-00Z1-AU1S-EQBF", "U55D-MW2R-082T-CCF9", "9JTI-52FI-L497-46AO", "HWAZ-HDBL-BIF9-ROFM", "4QNW-WV1Y-9GPX-SKLP", "BXAR-7K8U-9ON9-H708", "T56E-8JQJ-X9M4-9YC4", "CSIE-899P-5J3J-NB2B", "XDTN-2KX8-J5G0-24PZ" ]
}
```

---
{{< slide id="next-steps" >}}
## Wrap-up
{{% note %}}
Close out the session with your team.
{{% /note %}}

In this hands-on example, you have seen how Contrast Security works with your application to reveal vulnerabilities during your testing, and how we protect your application at runtime.

We encourage you to try different API calls and use this page as a reference:

```
https://api.contrastsecurity.com/
```

Your instructor will provide guidance as needed.

---
## Conclusion
This concludes the module.
Your instructor will inform you about how long your environment will remain in operation and if you will be covering other modules.
 
Go back to the [module list](../#/module-list)  
