+++
title = "Introduction to the Contrast Security User Interface"
chapter = true
description = "Module 1 is about introducing the major values of using Contrast Security"
weight = 13

+++

{{% section %}}
## But wait, there's more. Show the CLI.

In this section, we'll show you how to programmatically access the same information via API.  At Contrast Security, we recognize the value an API-enabled solution provides to DevOps teams to access data and information.  In the next few examples, we'll show you some of the same information from the UI in CLI form.

You can also reference the Contrast Security [API documentation] (https://api.contrastsecurity.com)

---

## List vulnerabilities

Here is a sample API call to get a brief summary of found vulnerabilities where details specific to your application and server are represented by the values in braces `{}`.

```bash
curl -X GET https://c.contrastsecurity.com/Contrast/api/ng/{orgUuid}/traces/{appId}/quick -H 'Authorization:{authorization-key}' -H 'API-Key:{API-Key}'
```

On your workstation, we've made it easy for you to run the command with a script:

```shell script
cd /Users/contrast/workshop/scripts
./m1-get-vulnerabilities.sh
```

The output is presented on the next page

---
## CLI output of Vulnerabilties

{{% note %}}
In this screen, we highlight the virtues of being a DevOps-friendly solution because of our API access at the CLI, or your other tooling.
When your teams integrate Contrast Security into your toolchain using the same techniques as other solutions, you amplify your capabilities by being able to automate decisions and process with the RIGHT information.
{{% /note %}}

In this sample output, you can see the format and structure of the results of an API call.  This type of capability empowers teams to add Contrast Security to their DevOps pipeline for any API-friendly tool.

```bash
{
  "success" : true,
  "messages" : [ "Vulnerability quick filters loaded successfully" ],
  "filters" : [ {
    "name" : "All",
    "count" : 18,
    "filterType" : "ALL"
  }, {
    "name" : "Open",
    "count" : 18,
    "filterType" : "OPEN"
  }, {
    "name" : "High Confidence",
    "count" : 0,
    "filterType" : "HIGH_CONFIDENCE"
  } ]
}
```
---
## Third-party Software
{{% note %}}
Describe the value of being able to see third-party software
{{% /note %}}

Contrast Security also identifies third party components used in the application.  This is an important set of information for teams that want to see the following:

- What third-party software are we including?
- What third-party software are we using?
- Are we in compliance with those third-party software components?

Contrast Security identifies only those libraries that are actually loaded by the application into the runtime.  Traditional SCA tools typically report on all libraries, regardless of use.  This means Contrast Security helps your team stay more focused on only those libraries in actual use, saving valuable time.


---
## Libraries
{{% note %}}
Describe the value of being to see the libraries in your application and IF they are in use.
{{% /note %}}

You can view libraries by clicking on Libraries in the top menu:

{{< figure src="../images/ce_libraries.png" style="border: 1px solid #000; max-width:auto; max-height:auto;">}}

---
## Library via API call
{{% note %}}
As with other aspects of Contrast Security, the API lets you programmatically access details.
{{% /note %}}

This information available via API as well:

```bash
curl -X GET https://ce.contrastsecurity.com/Contrast/api/ng/{orgUuid}/libraries -H 'Authorization:{authorization-key}' -H 'API-Key:{API-Key}'
```

Sample output looks like this:

```bash
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
## How to discover a new vulnerability
{{% note %}}
As your teams exercise software in their testing, you will find more vulnerabilities if they exist.
{{% /note %}}

In this part we will discover a new vulnerability in Webgoat application and examine the finding in Contrast Security.

It is important to reiterate that Contrast Security identifies vulnerabilities by looking at the normal traffic that goes through the application. With that in mind, let's identify a SQL injection in Webgoat with Contrast.

---
## Insert a Vulnerability
1. Log to Webgoat and navigate to Injection Flaws --> String SQL injection. Then enter Smith or any other string into the field and click on Go button:

{{< figure src="../images/wg_1.png" style="border: 1px solid #000; max-width:auto; max-height:auto;">}}

---
## Observe the new Vulnerability
2. Now let's go back to Contrast Security and click on Vulnerabilities. As you can see, Contrast identified to new vulnerabilities: XSS and SQL injection.

{{< figure src="../images/ce_4.png" style="border: 1px solid #000; max-width:auto; max-height:auto;">}}

Now you can click on either vulnerabilities to get more information.

---
## How to protect your application in production

Contrast Security not only shifts security left but also extends it to the right and protect running applications in productions from being exploited due to known or unknown vulnerabilities. Contrast Security uses the same instrumentation, in the fact, the same agent to do this.

---
## TeamServer Policies
{{% note %}}
Explain the value of policies and how they are applied to your organization as a pattern.  This is a time-saving capability that allows your teams to enable consistent and systematic approaches to your company's software security strategy.
{{% /note %}}

In your Community Edition, this feature is already enabled, and you can see that by navigating to the Policy submenu for WebGoat:

{{< figure src="../images/ce_5.png" style="border: 1px solid #000; max-width:auto; max-height:auto;">}}

---
## TeamServer Default Policies
{{% note %}}
Contrast Security provides default (Best practices) policies for your team as a start.  This helps your teams more quickly onboard the solution to be Contrast Ready.
{{% /note %}}

As you can see, Contrast Security is already protecting the application from exploiting most common vulnerabilities.

Now let's try attacking the application with SQL injection that Contrast discovered on the previous step. Go to the WebGoat site --> String SQL injection and add the following payload: Smith' or '98'='98. You will see that no results have been found as Contrast is protecting the application.

{{< figure src="../images/wg_3.png" style="border: 1px solid #000; max-width:auto; max-height:auto;">}}

---
## TeamServer policy example
{{% note %}}
While we don't recommend your team turn off protective policies, it is useful to see how they can be adjusted to permit or disallow activities.  This helps your teams best identify how to respond to vulnerabilities we detect in your software.
{{% /note %}}

However, if you try a regular query like "Smith", the request will go through and WebGoat will return some data.

Now let's try to turn Protect off and let's see what happens. If we go back to Contrast, we can turn off the SQL Injection rule as shown here:

{{< figure src="../images/ce_6.png" style="border: 1px solid #000; max-width:auto; max-height:auto;">}}

---
## Next Steps
{{% note %}}
TODO: Need to add more details here.
{{% /note %}}

Now you can try to exploit WebGoat again and see what happens


{{% /section %}}
