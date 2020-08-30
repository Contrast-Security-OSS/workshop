+++
title = "Module 1: First Time Contrast Users"
chapter = true
description = "The Contrast Security Workshop"
weight = 10
outputs = ["Reveal"]
layout = "bundle"
draft = false

[logo]
src = "../images/contrast-security-logo.png"
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
# Module 1: First Time Contrast Users

Jump to:
- [Module Introduction](#/module-introduction)
- [Introduction to TeamServer](#/introduction-to-teamserver)
- [The WebGoat application](#/the-webgoat-application)
- [Exploiting software](#/exploiting-software)
- [The Contrast API](#/the-contrast-api)
- [Libraries](#/libraries)
- [Next Steps](#/next-steps)

---
{{< slide id="module-introduction" >}}
## Module Introduction

In this section we'll guide you through a sequence of steps to run a sample application already configured for Contrast Security.  

This sequence will help you see the advantages of running an application with IAST built-in, because the more you exercise these applications, the more data we collect representing true execution of your code.  

We'll also show you how to exercise some exploits to observe how Contrast Security protects your  applications.

---
### Objectives

- Learn the basics of application security
- Gain familiarity with Contrast Security Assess
- Exercise tests to expose additional vulnerabilities

---
{{< slide template="info" >}}
### Time and Prerequisites
This module should take about 45 minutes to complete.

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
### What happens when you deploy an application?
When you deploy your instrumented application, a few things happen:
- The agent connects with the remote TeamServer
- The agent starts sending data for the application
- If licenses are available, details for the application are visible in TeamServer

In the next section, we'll look at working with the Contrast Security User Interface running on TeamServer.

---
{{< slide id="introduction-to-teamserver" >}}
## Introduction to TeamServer
There are several options to observe information about vulnerabilities in Contrast Security:

- The browser User Interface (UI)
- Programmatic/Command-Line (CLI) API access
- Via various integrations (Jira, Slack, IDEs, etc.)

We'll focus on both the UI and CLI options.

---
{{% note %}}
The dashboard is a landing page for all Contrast Security users - developers, operations, security, and administrators.  The different dashboard pages provide an overview for your team to quickly assess the status of the application security.  
{{% /note %}}

### Log on to TeamServer
Start by logging onto the Contrast Security UI at https://eval.contrastsecurity.com with the username and password your instructor supplied to you.

We'll use the default landing page's dashboard as the starting point for this module's exercise.

Your instructor will provide an overview of the TeamServer.  

{{< figure src="../images/04-dashboard.png#center" height="400px" text-align="center">}}
[See the full-sized picture](../images/04-dashboard.png)

---
{{% note %}}
In this slide, we should have already setup each user with their running applications so data has been sent to TeamServer.

The time saved by automatically onboarding and offboarding applications is huge.  No more complex rules, setup, or configuration.
{{% /note %}}

### TeamServer Notification
Click on the bell icon in the upper right-hand corner to see notifications alerting us to the automatic onboarding of our new server and application.

{{< figure src="01-notifications-new-applications.png" height="400px" >}}
[See the full-sized picture](01-notifications-new-applications.png)

At the onset of this workshop, your instructor would have deployed vulnerable applications and configured them with an agent using your identity.  Your application is already onboarded on TeamServer, and this easy onboarding process works very well for teams constantly creating and deleting infrastructure.

At Contrast, we've learned that as team shift more of their workload to ephemeral and cloud-based environments, automatic onboarding is a big time-saver.  This automatic registration lets teams automatically opt into a security model.

---
### TeamServer Dashboard
Back to the main dashboard, you should see a summary about your deployed applications:
- Number of Applications, Libraries and Servers
- Average time to remediate vulnerabilties
- Current vulnerabilities, listed by severity
- Current attacks

{{< figure src="../images/04-dashboard.png#center" height="400px" >}}
[See the full-sized picture](../images/04-dashboard.png)

---
### Real-Time Visibility
As you and your teams onboard applications, their results will be added to Contrast Security for better visibility into the state of your application development in real time.

This screenshot is an example of a dashboard after a few hundred applications have been onboarded.

{{< figure src="m1-dashboard.png" height="400px" >}}
[See the full-sized picture](m1-dashboard.png)

---
### Ongoing Data Collection
From the onset, you accumulate results in TeamServer.  This is the first of many advantages of IAST, where your team's day-to-day exercising and testing automatically generates meaningful results of security vulnerabilities.  As you and your teams exercise more of your software, we'll keep track of new vulnerabilities and their remediation.

This means you can add Contrast Security to your existing workflow and start using results immediately.
There is high value to all members of your team when you can leverage this information with minimal configuration.

Click into the Application heading to see how TeamSerer uncovers new vulnerabilities.

{{< figure src="04-dashboard-command-bar-applications.png" >}}
[See the full-sized picture](04-dashboard-command-bar-applications.png)

---
{{< slide id="the-webgoat-application" >}}
## The WebGoat application
Click into your running instance of Webgoat as identified in your welcome email.

{{< figure src="03-applications.png" >}}
[See the full-sized picture](03-applications.png)

---
{{< slide template="note" >}}
{{% note %}}
Instructors: Describe each page as needed for your target audience.  Toggle between the presentation and a live view of TeamServer to highlight features.
{{% /note %}}
### Let's see the data we've already collected.
Contrast Security starts by collecting information the moment your application is deployed.  We'll review what different TeamServer pages bring to your team.

- Overview
- Vulnerabilities
- Attacks
- Libraries
- Activity
- Route Coverage
- Flow Map
- Policy

---
### Webgoat Overview
{{% note %}}
For many users, collecting data as we use the application is a brand-new concept.  Most users are familiar with static code analysis and its outcomes, fewer have been exposed to the more modern approach of IAST.
{{% /note %}}

As soon as you run your registered application, Contrast Security will collect information.  The more you exercise the application with manual or automated tests, the more data we'll report.

{{< figure src="09-webgoat-overview.png" height="500px" >}}
[See the full-sized picture](09-webgoat-overview.png)

---
### The Vulnerabilities Page
This vulnerabilities page shows what Contrast Security has discovered in your application, organized to help you easily find the information you want.
 
{{< figure src="09-webgoat-vulnerabilities.png" height="500px"
caption="[See the full-sized picture](09-webgoat-vulnerabilities.png)"
>}}

---
### The Attacks Page
Contrast Security shows the attacks on your system.  At the onset, we don't yet have attacks but we'll add some later in this module.
{{< figure src="09-webgoat-attacks-none.png"  height="500px"
caption="[See the full-sized picture](09-webgoat-attacks-none.png)"
>}}

---
### The Libraries Page
Contrast Security shows the different libraries included in your application, plus _if the library is actually used._  This is an improvement over knowing the library is present, but not in use.
  
When your teams see actual use, they can focus on libraries with greatest impact.
 
{{< figure src="09-webgoat-libraries.png"
caption="[See the full-sized picture](09-webgoat-libraries.png)"
>}}

---
### The Route Coverage page
Contrast Security shows the path, or route, through your application as we detect where vulnerabilities exist.  As you exercise the application with acutal use cases, we will see this page fill in.
{{< figure src="09-webgoat-route-coverage.png" 
height="500px" 
caption="[See the full-sized picture](09-webgoat-route-coverage.png)"
>}}

---
### The Policy Page
Contrast Security gives your team fine-grained control over the rules and the outcomes Contrast Security applies to your application.

{{< figure src="09-webgoat-policy.png" height="500px"
caption="[See the full-sized picture](09-webgoat-policy.png)"
>}}

---
{{< slide id="exploiting-software" >}}
## Exploiting software - SQL Injection
{{% note %}}
In this part, we'll show how we can detect a SQL injection without having to do an attack.
{{% /note %}}
Now let's exploit the software for some known vulnerabilities.  A common exploit is SQL injection.

SQL injections are an OWASP Top-10 vulnerability that allow an attacker to insert extra commands into a text field.  We'll look at an example in this section and show the results in TeamServer.

--- 
### Navigate to the application
{{% note %}}
Explain the nature of the WebGoat application, and some of the navigation options.
{{% /note %}}

Your instructor will give you application details in this format:

```text
yourname-java-webgoat-svc - http://52.149.201.3:18101/WebGoat
```

Login with the WebGoat Admin presented on the login page. 

{{< figure src="14-webgoat-mainpage.png" height="500px"
caption="[See the full-sized picture](14-webgoat-mainpage.png)"
>}}

---
### WebGoat: Expose a SQL Injection Vulnerability
Log to Webgoat and navigate to Injection Flaws --> String SQL injection. Then enter the last name 'Smith' into the field and click on Go button.  You should see a response indicating that last name is not matched.

From our perspective, this is an ordinary data-entry field.  Normal scanning and user testing usually doesn't reveal there is a security vulnerability on this page.  Let's examine the results.

{{< figure src="wg_1.png" height="400px" text-align="center">}}
[See the full-sized picture](wg_1.png)

---
### TeamServer: SQL Injection Overview
{{% note %}}
Instructor: You may have to allocate licenses to users.

This section examines the details for a single exploit.
Explain how the look-and-feel is consistent, and the information is designed to help the developer quickly identify the vulnerability with the specific data supplied to the application.

The Details page shows the path of our vulnerability.  This is an improvement beyond the URL, because Contrast also shows how the vulnerability affects running code.  
{{% /note %}}

You should see a new [notification](09-sql-injection-notifications.png) indicating your application has a new critical vulnerability.  Click into the application to find the  <b>CRITICAL</b> severity. Click into the vulnerability to see the details.

Review the contents of the "Overview" and then the "Vulnerabilities" subpage to see the list of Vulnerabilities, including the new one identified as Critical.

{{< figure src="09-webgoat-dashboard.png"  height="500px"
caption="[See the full-sized picture](09-webgoat-dashboard.png)"
>}}

---
### TeamServer: Vulnerability Details
As we navigate through the sub-pages for the new vulnerability, notice how the name we supplied is used to establish better context for the vulnerability.

This example showcases one of the many strengths of Contrast Security.  The ordinary operation of entering a last name reveals to the tester there is a real vulnerability within the code.

{{< figure src="09-webgoat-sql-injection-overview.png"  height="500px"
caption="[See the full-sized picture](09-webgoat-sql-injection-overview.png)"
>}}

---
### TeamServer: Vulnerability Details

The details page provides a clear narrative about the vulnerability, and highlights the path the request into the application code.

{{< figure src="09-webgoat-sql-injection-details.png"    height="500px"
caption="[See the full-sized picture](09-webgoat-sql-injection-details.png)">}}

---
### TeamServer: SQL Injection HTTP Info explained
Next, click into the "HTTP Info subpage" to see HTTP details of the operation, and the chance to re-run this request from TeamServer.

Your instructor will work through the details on this page and help explain how this information helps a brand-new users of Contrast Security quickly identify vulnerabilities in their software and how to fix it.

{{< figure src="09-webgoat-sql-injection-http-info.png"   height="500px"
caption="[See the full-sized picture](09-webgoat-sql-injection-http-info.png)" >}}

---
### TeamServer: SQL Injection "How To Fix"

After identifying the vulnerability, Contrast Security also explains how you can fix it.  In addition to a reference implementation, we also offer links to external sources further explaining the vulnerability.  This is our way of ensuring you have the best information available to address software vulnerabilities.

{{< figure src="09-webgoat-sql-injection-howto-fix.png"   height="500px"
caption="[See the full-sized picture](09-webgoat-sql-injection-howto-fix.png)" >}}

---
{{< slide id="the-contrast-API" >}}
## The Contrast API

Next, let's look at how your teams can leverage the Contrast API.

The TeamServer User Interface is designed to help users find and see information quickly and easily.  The TeamServer utilizes an API on the backend, and Contrast Security has made this API available to external users.

Contrast Security provides a number of out-of-the-box integrations for Jira, Jenkins, Slack, and other popular tools to provide fast feedback.  Contrast Security also provides programmatic access for teams that wish to integrate with their existing systems.

You can also reference the Contrast Security [API documentation] (https://api.contrastsecurity.com).
 
---
### API Overview

In this section, we'll show you how to programmatically access the same information via API.  We'll compare some of the results from the User Interface and the CLI to show consistency.

To programmatically use the API, you will need specific details to make them work.  We'll guide you in the next tasks with those details.

Real world teams will see familiar patterns and techniques in the Contrast API if they have used others.  Teams have taken great liberty using their favorite programming or scripting languages to automate against our API in their preferred toolchain.

The examples here will illustrate the basics.

---
### Source code: scripts

At Contrast Security, we've published our workshop files to GitHub so you can access the content there.  Let's start by getting the code for this project so you can run some script.  We'll assume you are always working from the same base directory as shown by the %HOMEPATH% reference below.
 
From your workstation, open a command prompt and run the following command:

```text
cd %HOMEPATH%
git clone https://github.com/Contrast-Security-OSS/workshop
cd workshop
```

The command-line commands you will run will be from the checked out folder, named `workshop.`

---
### Your Application ID

The first piece of information we'll get is the unique Application ID for your running instance of WebGoat.  Every application has a unique identifier, and we'll find ours in the URL when we're on a page that shows your WebGoat application:
 
`https://eval.contrastsecurity.com/Contrast/static/ng/index.html#/c992a0ef-e965-4f92-a410-e09256a78758/applications/2ac60539-9d58-4365-a006-dc0fc51efc7e`

The two embedded IDs are identified as follows:

- `c992a0ef-e965-4f92-a410-e09256a78758`

The first value is your organization UUID, or `{org_uuid}`.  Your `{org_uuid}` is where you collect the details of your various applications specific to your organization.  In this case, the organization is made up of one user - you.

- `2ac60539-9d58-4365-a006-dc0fc51efc7e`
 The second value is your application ID, or`{app_id}`.  Your `{app_id}` is specific to your running instance of your WebGoat application.

Make note of the `app_id` because we'll need this later.

---
### User API details

In TeamServer, Click on your name in the upper-right hand corner and then select "Oragnization Settings" to find your API details.

{{< figure src="16-user-details.png">}}

Next, click on the API heading on the left to get those details
{{< figure src="16-user-details-api.png"   height="300px"
caption="[See the full-sized picture](16-user-details-api.png)" >}}

Let's look at the content of that page.

---
### REST API Details

The REST API page has the details you need to complete programmatic access to the server.  This is the entire list of information:
- `{org_uuid}`
- `{api_key}`
- `{url}`
- `{user_name}`
- `{service_key}`

{{< figure src="16-user-details-api-rest.png" height="300px" 
caption="[See the full-sized picture](16-user-details-api-rest.png)" >}}

NOTE: If you examined your `contrast_security.yaml` file, you will notice some of the same fields.
  
---
### Generate Sample API Request

The last piece of information is your Authorization Key.  Click on the "Generate Sample API Request" button on the Rest API Details page. 

The Authorization is the string of characters following the `-H 'Authorization:` text.  This Authorization value is necessary for REST API transactions.  You'll use this information in CLI, or your preferred programming environment.  This final piece is:

- `{authorization_key}`

{{< figure src="16-user-details-api-auth.png" >}}

---
### Setup files

In this module, we provide helper scripts to make it easier for you to run commands.

Run this setup script to make things a little easier, where you will be prompted for these values:
- `{org_uuid}`
- `{api_key}`
- `{authorization_key}`
- `{app_id}`

In the checkout directory (should be "workshop"), execute the following commands:
```text
cd %HOMEPATH%\workshop\scripts\module1
setup.bat
```

The setup script will prompt you for details to create helper scripts.  These helper scripts are meant to make it easier to run API commands.  The outputs will be scripts with the content you need.  You can always re-run `setup.bat` to reset your scripts.

---
### Sample API Request
If you navigate to Your Account->Profile, you'll see a button to "Generate Sample API Requst."  This is a multi-line command suitable for Linux distributions, but not convenient for Windows environments.  The next page will help you with that command.

{{< figure src="16-your-account-profile.png" height="400px"
caption="[See the full-sized picture](16-your-account-profile.png)"
>}}

---
### Sample API Request - Output

We created a helper script that does the operation for you, which you can run with the following command:

```text
cd %HOMEPATH%\workshop\scripts\module1
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

Next, navigate to your WebGoat application and click into the Libraries subpage to see a page similar to what is shown below.  When you see the list of several dozen libraries, you may be reminded how teams will want to use the information presented here in their automation tasks.  

{{< figure src="09-webgoat-libraries.png"
caption="[See the full-sized picture](09-webgoat-libraries.png)"
>}}

---
### Third-party Software
{{% note %}}
Describe the value of being able to see third-party software
{{% /note %}}

When Contrast Security identifies third party components in your application, your teams want to know the following:
- What third-party software are we including?
- What third-party software are we using?
- Are we in compliance with those third-party software components?

Contrast Security identifies only those libraries that are actually loaded by the application into the runtime.  Traditional SCA tools typically report on all libraries, regardless of use.  This means Contrast Security helps your team stay more focused on only those libraries in actual use, saving valuable time.  

Your team will want to automate processes to find details _interesting_ to them.  Let's see how that works next.

---
### Library via API call
{{% note %}}
As with other aspects of Contrast Security, the API lets you programmatically access details.
{{% /note %}}

This information available via API as well:

```bash
curl -X GET https://ce.contrastsecurity.com/Contrast/api/ng/{org_uuid}/libraries -H "Authorization:{authorization_key}" -H "API-Key:{api_key}"
```

On your workstation, we've made it easy for you to run the command with a script:

```shell script
cd %HOMEPATH%/workshop/scripts/module1
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

```bash
curl -X GET https://eval.contrastsecurity.com/Contrast/api/ng/{org_uuid}/traces/{app_id}/quick -H "Authorization:{authorization_key}" -H "API-Key:{api_key}"
curl -X GET https://eval.contrastsecurity.com/Contrast/api/ng/{org_uuid}/traces/{app_id}/ids -H "Authorization:{authorization_key}" -H "API-Key:{api_key}"
```

On your workstation, we've made it easy for you to run the command with a script where we filled in the missing details.

```shell script
cd %HOMEPATH%/workshop/scripts/module1
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
### Contrast Protect
In this part of the module, you will actively attack the software and observe how Contrast Protects your application.

---
### WebGoat: SQL Injecting Data Entry
Let's revisit a previous page and perform an actual SQL Injection string.  In the previous example, we entered a normal name and were alerted of the vulnerability.  Here, we'll do an actual attack.

In the box to enter your last name, enter the following typical SQL Injection text.  The application will announce you correctly performed a SQL Injection.

```text
Smith' or '98'='98
```

This is an example of an attack, and Contrast Security can protect your application. Let's review in the next screens.

{{< figure src="14-webgoat-sql-injection.png" height="500px"
caption="[See the full-sized picture](14-webgoat-sql-injection.png)"
>}}

---
### How to protect your application in production

Contrast Security not only shifts security left but also extends it to the right and protect running applications in productions from being exploited due to known or unknown vulnerabilities. Contrast Security uses the same instrumentation, in the fact, the same agent to do this.

---
### Contrast Protect

Navigate to your Webgoat Application, and lok through the Attacks subpage.  You'll see an exploit on your application.  At the onset, Contrast Security only Monitors this specific vulnerability.  We will look at the policy and change it so Contrast Security is more active.

{{< figure src="17-webgoat-attacks.png" >}}


---
### TeamServer Policies
{{% note %}}
Explain the value of policies and how they are applied to your organization as a pattern.  This is a time-saving capability that allows your teams to enable consistent and systematic approaches to your company's software security strategy.

Contrast Security provides default (Best practices) policies for your team as a start.  This helps your teams more quickly onboard the solution to be Contrast Ready.

{{% /note %}}

As you can see, Contrast Security is already protecting the application from exploiting most common vulnerabilities.  The image below has some filtering enabled so we can focus on SQL Injection.  You should notice the policy is to MONITOR in the development environment.  Change the polilcy to BLOCK.
 

{{< figure src="17-webgoat-protect-policy.png">}}

 Let's retry the SQL Injection again with a new value.

```text
Smith' or '1'='1
```

---
### WebGoat with Protect Enabled

This time, you will see a different result on the webpage showing no results matched.

Let's look at TeamServer to see what happened there.

{{< figure src="17-webgoat-protect-enabled.png" height="500px"
caption="[See the full-sized picture](17-webgoat-protect-enabled.png)"
>}}

---
### TeamServer Protect - Probed

We now have a new entry showing your application was attacked again, but the status is probed.  This is how Contrast Security lets you know that we detected a known SQL injection and stopped it.  Contrast reports the probe to your team, but the attacker receives a response that _does not_ reveal the vulnerability.  This is very powerful because it shows how Contrast Security is able to protect your running applications against these types of attacks.

{{< figure src="17-webgoat-protect-probed.png" 
caption="[See the full-sized picture](17-webgoat-protect-probed.png)"
>}}

---
{{< slide id="next-steps" >}}
## Wrap-up
{{% note %}}
Close out the session with your team.
{{% /note %}}

In this hands-on example, you have seen how Contrast Security works with your application to reveal vulnerabilities during your testing, and how we protect your application at runtime.

We encourage you to try different attacks
Now you can try to exploit WebGoat again and see what happens.  Change some policies for your application, or try different exercises within WebGoat.

Your instructor will provide guidance as needed.

---
## Conclusion
This concludes the module.
Your instructor will inform you about how long your environment will remain in operation and if you will be covering other modules.
 