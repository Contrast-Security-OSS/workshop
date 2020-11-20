+++
title = "Module 1: First Time Contrast Users"
chapter = true
description = "The Contrast Security Workshop"
weight = 10
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
# Module 1: First Time Contrast Users

Jump to:
- [Module Introduction](#/module-introduction)
- [The WebGoat application](#/the-webgoat-application)
- [Introduction to TeamServer](#/introduction-to-teamserver)
- [LAB: Testing software and SQLi](#/testing-software)
- [LAB: Cross-Site-Scripting](#/cross-site-scripting)
- [LAB: Contrast Protect](#/contrast-protect)
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
This module should take about 60 minutes to complete.

Be sure to have completed the [prerequisites](../#/setup-and-prerequisites)  

---
{{< slide id="the-webgoat-application" >}}
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

Your instructor deployed applications configured with your TeamServer credentials and will supply connection details for your applications as a URLs for each vulnerable application.

---
### Webgoat Overview
{{% note %}}
For many users, collecting data as we use the application is a brand-new concept.  Most users are familiar with static code analysis and its outcomes, fewer have been exposed to the more modern approach of IAST.
{{% /note %}}

Contrast Security collects information as soon as you run your registered application.  The more you exercise the application with manual or automated tests, the more data we'll report.

You will see evidence of this data collection as you use your application that reveals exploits *even though you weren't testing for those cases.*

---
{{< slide id="testing-software" >}}
## LAB: Testing software

In this section, we will reveal a common application security flaw known as a SQL Injection with simple user testing.

We'll provide a brief overview, show it WebGoat, and then highlight the results in TeamServer.

--- 
### Navigate to the application
{{% note %}}
Explain the nature of the WebGoat application, and some of the navigation options.

Logging in as guest or admin are acceptable, but we'll go with guest for this exercise. 
{{% /note %}}

Your instructor gave you application details in this format:

```
yourname-java-webgoat-svc - http://52.149.201.3:18101/WebGoat
```

Navigate to your supplied URL and log on as the WebGoat *guest* presented on the login page. 

{{< figure src="14-webgoat-login.png"  height="300px" text-align="center" >}}

---
### Webgoat Main Page

The home page of the Webgoat application shows you the following:
- Main topics on the left
- Content in the middle

Let's navigate through the headings to get to our different flaws.

{{< figure src="14-webgoat-mainpage.png" height="300px" text-align="center">}}
[See the full-sized picture](14-webgoat-mainpage.png)

---
## SQL Injection
{{% note %}}
Explain SQL Injection to new users and then show the process.
{{% /note %}}

SQL Injections are a flaw that allow an attacker to send extra, untrusted data to a query.  The result is an attacker can run unintended extra commands.

Injections are the #1 Web Application Security Risk in the OWASP Top-Ten.

*see https://owasp.org/www-project-top-ten/OWASP_Top_Ten_2017/Top_10-2017_A1-Injection*

---
### Navigating to SQL Injections

In the subheadings on the left, expand the section entitled, "Injection Flaws."

Once expanded, click on the "String SQL Injection" option in the list." 

{{< figure src="14-webgoat-expand-injection.png" height="300px" text-align="center">}}
[See the full-sized picture](14-webgoat-expand-injection.png)

---
### WebGoat: Expose a SQL Injection Vulnerability
The *String SQL Injection* page is an example of the content in WebGoat.  Their content provides instructions, data-entry exercises, and usually a challenge.  Some challenges include hints and solutions.

Enter your name in the text field (or `Smith`) and press the `Go!` button.

You will see a response indicating, `No results matched.  Try again.`

This is a typical data-entry test.  Normal scanning and user testing do not reveal security vulnerabilities on this page, but Contrast Security will.  Let's examine the results from Contrast Security.

{{< figure src="14-webgoat-name.png" height="300px" text-align="center">}}
[See the full-sized picture](14-webgoat-name.png)

---
### What happens when you deploy an application?
When you deploy your instrumented application, a few things happen:
- The agent connects with the Contrast Server (TeamServer)
- The agent starts sending data for the application
- If licenses are available, details for the application are visible in TeamServer

Next, we'll look at the Contrast Security User Interface running on TeamServer.

---
{{< slide id="introduction-to-teamserver" >}}
## Introduction to TeamServer
There are several options to observe information about vulnerabilities in Contrast Security:

- The browser User Interface (UI)
- Programmatic/Command-Line (CLI) API access
- Via various integrations (Jira, Slack, IDEs, etc.)

In this module we'll focus on the UI.

---
{{% note %}}
The dashboard is a landing page for all Contrast Security users - developers, operations, security, and administrators.  The different dashboard pages provide an overview for your team to quickly assess the status of the application security.  
{{% /note %}}

### Log on to TeamServer
{{% note %}}
Instructor: You may have to allocate licenses to users.

This section examines the details for a single exploit.
Explain how the look-and-feel is consistent, and the information is designed to help the developer quickly identify the vulnerability with the specific data supplied to the application.

The Details page shows the path of our vulnerability.  This is an improvement beyond the URL, because Contrast also shows how the vulnerability affects running code.  
{{% /note %}}
Start by logging onto the Contrast Security UI at https://eval.contrastsecurity.com with the username and password your instructor supplied to you.

{{< figure src="04-teamserver-login.png#center" height="400px" text-align="center">}}
[See the full-sized picture](04-teamserver-login.png)

---
### TeamServer Dashboard
The dashboard presents a summary about your deployed applications:
- Number of Applications, Libraries and Servers
- Average time to remediate vulnerabilties
- Current vulnerabilities, listed by severity
- Current attacks

{{< figure src="04-dashboard.png#center" height="300px" >}}
[See the full-sized picture](04-dashboard.png)

---
### Real-Time Visibility
The dashboard is designed to give you a fast understanding of your organization's applications, with links you would use to better understand the details.

As you and your teams onboard applications, their results will be added to Contrast Security for better visibility into the state of your application development in real time.

This screenshot is an example of a dashboard after a few hundred applications have been onboarded.

{{< figure src="m1-dashboard.png" height="300px" >}}
[See the full-sized picture](m1-dashboard.png)

---
### TeamServer Notification
{{% note %}}
In this slide, we should have already setup each user with their running applications so data has been sent to TeamServer.

The time saved by automatically onboarding and offboarding applications is substantial.  No more complex rules, setup, or configuration.
{{% /note %}}

Click on the bell icon in the upper right-hand corner to see notifications alerting us to the automatic onboarding of your new appplications and their servers.

We'll even see we have a new <b>CRITICAL</b> vulnerability we found from our earlier user-input test.

{{< figure src="14-webgoat-injection-notification.png" height="300px" text-align="center">}}
[See the full-sized picture](14-webgoat-injection-notification.png)

---
### TeamServer: Critical Notification
{{% note %}}
Instructor: You may have to allocate licenses to users.

This section examines the details for a single exploit.
Explain how the look-and-feel is consistent, and the information is designed to help the developer quickly identify the vulnerability with the specific data supplied to the application.

The Details page shows the path of our vulnerability.  This is an improvement beyond the URL, because Contrast also shows how the vulnerability affects running code.  
{{% /note %}}

Notifications are useful when first onboarding an application or first uncovering a vulnerability.

At Contrast, we've learned that as teams shift more of their workload to ephemeral and cloud-based environments, automatic onboarding is a valuable time-saver.  This automatic registration lets teams automatically opt into a security model.

As you and your teams exercise more of your software, we'll keep track of new vulnerabilities as soon as they are discovered.  There is high value to all members of your team when you can leverage this information with minimal configuration.

---
### Applications

Everyday Contrast users will go straight to the critical vulnerability from the notification page.  We will navigate through Applications to see more about Contrast Security.

Click into the *Applications* heading to see the applications in your organization.

{{< figure src="04-dashboard-command-bar-applications.png" >}}
[See the full-sized picture](04-dashboard-command-bar-applications.png)

---
### Applications list

The applications page shows all of your applications, organized to let see information quickly and easily.  You can filter or search to narrow down your list by name, tags, language, and other attributes.

In this example, we entered the name `webgoat` to filter for those applications.

Find your application by using your name as filter, and click into your webgoat application.


{{< figure src="03-applications.png" height="300px">}}
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

Keep an eye on the name of your running instance of Webgoat as identified in your welcome email.

---
### Webgoat Overview
{{% note %}}
For many users, collecting data as we use the application is a brand-new concept.  Most users are familiar with static code analysis and its outcomes, fewer have been exposed to the more modern approach of IAST.
{{% /note %}}

Your WeGoat application dashboard features quite a bit of information to help you understand its state.  Here, we'll focus on the critical Vulnerability.

Your instructor may highlight other aspects of this page. 

{{< figure src="09-webgoat-dashboard.png" height="300px" >}}
[See the full-sized picture](09-webgoat-dashboard.png)

---
### The Vulnerabilities Page
This vulnerabilities page shows what Contrast Security has discovered in your application, organized to help you easily find the information you want.

[Skip to Critical SQLi Vulneratiblity.](#/critical-vulnerability)

{{< figure src="09-webgoat-vulnerabilities.png" height="300px"
caption="[See the full-sized picture](09-webgoat-vulnerabilities.png)"
>}}

---
### The Attacks Page
Contrast Security shows the attacks on your system.  At the onset, we don't yet have attacks but we'll add some later in this module.
{{< figure src="09-webgoat-attacks-none.png"  height="300px"
caption="[See the full-sized picture](09-webgoat-attacks-none.png)"
>}}

---
### The Libraries Page
Contrast Security shows the different libraries included in your application, plus _if the library is actually used._  This is an improvement over knowing the library is present, but not in use.
  
When your teams see actual use, they can focus on libraries with greatest impact.
 
{{< figure src="09-webgoat-libraries.png" height="300px"
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

{{< figure src="09-webgoat-policy.png" height="300px"
caption="[See the full-sized picture](09-webgoat-policy.png)"
>}}

---
{{< slide id="critical-vulnerability" >}}

### TeamServer: Critical Vulnerability Details
Clicking into the Critical vulnerability gives you an overview page summarizing the vulnerability with the name, and details on how it was detected.  This is good context for teams when they review. 

This example showcases one of the many strengths of Contrast Security.  The ordinary test of entering a last name reveals a real vulnerability within the code.

{{< figure src="09-webgoat-sql-injection-overview.png" height="300px"
caption="[See the full-sized picture](09-webgoat-sql-injection-overview.png)"
>}}

---
### Additional Vulnerability Details

Next, let's review the details for these sections:
- Details
- HTTP Info
- How to Fix
- Notes
- Discussion

Let's go back to the Application Vulnerabilities page

---
### TeamServer: Vulnerability Details

The details page provides a clear narrative about the vulnerability, and highlights the path the request into the application code.

{{< figure src="09-webgoat-sql-injection-details.png"    height="300px"
caption="[See the full-sized picture](09-webgoat-sql-injection-details.png)">}}

---
### TeamServer: SQL Injection HTTP Info explained
Next, click into the "HTTP Info subpage" to see HTTP details of the operation, and the chance to re-run this request from TeamServer.

Your instructor will work through the details on this page and help explain how this information helps a brand-new users of Contrast Security quickly identify vulnerabilities in their software and how to fix it.

{{< figure src="09-webgoat-sql-injection-http-info.png"   height="300px"
caption="[See the full-sized picture](09-webgoat-sql-injection-http-info.png)" >}}

---
### TeamServer: SQL Injection "How To Fix"

After identifying the vulnerability, Contrast Security also explains how you can fix it.  In addition to a reference implementation, we also offer links to external sources further explaining the vulnerability.  This is our way of ensuring you have the best information available to address software vulnerabilities.

{{< figure src="09-webgoat-sql-injection-howto-fix.png"   height="300px"
caption="[See the full-sized picture](09-webgoat-sql-injection-howto-fix.png)" >}}

---
### SQL Injection Next Steps

You are encouraged to explore the subsection for SQL Injection to see the materials, the problems, and the solutions to this common Web Application Security Flaw.

---
{{< slide id="cross-site-scripting" >}}
## Cross-Site Scripting (XSS)
{{% note %}}
Explain XSS to new users and then show the process.
{{% /note %}}

Cross-Site Scripting (XSS) is a flaw that allow an attacker to include untrusted data in a new web page.  The result is an attacker can execute scripts in a victim's browser.

XSS are in the OWASP Top-Ten Web Application Security Risks.

*see https://owasp.org/www-project-top-ten/OWASP_Top_Ten_2017/Top_10-2017_A7-Cross-Site_Scripting_(XSS)*

---
### Navigating to XSS

In the subheadings on the left, expand the section entitled, "Cross-Site Scripting (XSS)."

Once expanded, click on the "LAB: Cross Site Scripting" option in the list. 

{{< figure src="16-webgoat-xss-navigate.png" height="300px" text-align="center">}}
[See the full-sized picture](16-webgoat-xss-navigate.png)

---
### WebGoat: Expose a XSS Vulnerability
The *LAB: Cross Site Scripting* page is an example of the flaw.

Here, we'll follow the instructions and log on as one user and run a standard query.

The flaw is that our query is vulnerable to a cross-site scripting attack.

On this page, Login as "Tom Cat" and use the password, "tom" as directed.

{{< figure src="16-webgoat-xss-mainpage.png" height="300px" text-align="center">}}
[See the full-sized picture](16-webgoat-xss-mainpage.png)

---
### WebGoat: Expose a XSS Vulnerability - Part 2
In the next screen, click on the "SearchStaff" button to initiate a search screen.

{{< figure src="16-webgoat-xss-searchstaff.png" height="300px" text-align="center">}}
[See the full-sized picture](16-webgoat-xss-searchstaff.png)

---
### WebGoat: Expose a XSS Vulnerability - Part 3
On the "Search for User" page, enter the name "Jerry" and then click on the "FindProfile" button.

{{< figure src="16-webgoat-xss-findprofile.png" height="300px" text-align="center">}}
[See the full-sized picture](16-webgoat-xss-findprofile.png)

---
### WebGoat: Expose a XSS Vulnerability - Part 4
The results will show the details for the user "Jerry" as an ordinary screen.  However, WebGoat is a deliberately vulnerable application where you could have inserted additional commands into the previous screen to gain access.

Let's look at the results in TeamServer.

{{< figure src="16-webgoat-xss-findprofile-results.png" height="300px" text-align="center">}}
[See the full-sized picture](16-webgoat-xss-findprofile-results.png)

---
### TeamServer: Cross-Site Scripting Overview
{{% note %}}
Instructor: You may have to allocate licenses to users.

This section examines the details for a single exploit.
Explain how the look-and-feel is consistent, and the information is designed to help the developer quickly identify the vulnerability with the specific data supplied to the application.

The Details page shows the path of our vulnerability.  This is an improvement beyond the URL, because Contrast also shows how the vulnerability affects running code.  
{{% /note %}}

Navigate to Teamserver (https://eval.contrastsecurity.com/Contrast) with the credentials supplied to you.

You should see a new notification indicating your application has a new High vulnerability.  Click into the lnk for the High vulnerability to take you directly to the next page.  

Alternatively, you can navigate from the Applications and follow links to find this new vulnerability with a name similar to "Cross-Site Scripting from "search_name" Parameter on "/WebGoat/attack" page."

{{< figure src="16-webgoat-xss-notifications.png" height="300px" text-align="center">}}
 
---
### TeamServer: XSS Vulnerability Details
The overview page summarizes the XSS vulnerability similarly to the previous SQL Injection example.

Again, you can see the highlighted input data to help your team more quickly diagnose and troubleshoot vulnerabilities.

{{< figure src="16-webgoat-xss-overview.png"  height="300px">}}
[See the full-sized picture](16-webgoat-xss-overview.png)

---
### Additional Vulnerability Details

The XSS vulnerability also have their corresponding pages to highlight these details:
- Details
- HTTP Info
- How to Fix
- Notes
- Discussion

You team can also use these resources and included links to help work through a solution for this flaw.

---
### Cross-Site Scripting (XSS) Next Steps

You are encouraged to explore the subsection for XSS to see the materials, the problems, and the solutions to this common Web Application Security Flaw.

---
## Path Based Access Control
{{% note %}}
Explain path-based access control
{{% /note %}}

Broken Access Control is a flaw that allows an attacker to access pages or files they do not have access to.  The result is an attacker can see data or files not intended for them.

Broken Access Control is in the OWASP Top-Ten Web Application Security Risks.

*see https://owasp.org/www-project-top-ten/OWASP_Top_Ten_2017/Top_10-2017_A5-Broken_Access_Control*

---
### Navigating to Access Control Flaws

In the subheadings on the left, expand the section entitled, "Access Control Flaws"

Once expanded, click on the "Bypass a Path Based Access Control Scheme." 

{{< figure src="17-webgoat-path-navigate.png" height="300px" text-align="center">}}
[See the full-sized picture](17-webgoat-path-navigate.png)

---
### WebGoat: Bypass a Path Based Access Control Scheme
The *Bypass a Path Based Access Control Scheme* page is an example of the flaw.

Here, we'll follow the instructions and log on as one user and run a standard file-lookup.

The flaw is that our lookup is vulnerable to an attack where you can access other files in in the system.

On this page, click on the first entry named, "SameOriginPolicyProtection.html" and press the "View File" button.

{{< figure src="17-webgoat-path-mainpage.png" height="300px" text-align="center">}}
[See the full-sized picture](17-webgoat-path-mainpage.png)

---
### WebGoat: Bypass a Path Based Access Control Scheme - Part 2

When you press "View File", you will see the contents of the file you selected below the data-entry page.

You can click on other filenames to see their contents.

{{< figure src="17-webgoat-path-results.png" height="300px" text-align="center">}}
[See the full-sized picture](17-webgoat-path-results.png)

Let's examine the results in TeamServer.

---
### TeamServer: Path Traversal Notification
{{% note %}}
Instructor: You may have to allocate licenses to users.

This section examines the details for a single exploit.
Explain how the look-and-feel is consistent, and the information is designed to help the developer quickly identify the vulnerability with the specific data supplied to the application.

The Details page shows the path of our vulnerability.  This is an improvement beyond the URL, because Contrast also shows how the vulnerability affects running code.  
{{% /note %}}

Navigate to Teamserver (https://eval.contrastsecurity.com/Contrast) with the credentials supplied to you.

You should see a new notification indicating your application has a new High vulnerability.  Click into the lnk for the High vulnerability to take you directly to the next page.  

Alternatively, you can navigate from the Applications and follow links to find this new vulnerability with a name similar to "Path Traversal from "File" Parameter on "/WebGoat/attack" page."

{{< figure src="17-webgoat-path-notifications.png" height="400px" text-align="center">}}
 
---
### TeamServer: Path Traversal Vulnerability Overview
The overview page summarizes the Path Traversal vulnerability similarly to previous examples in this workshop.
 
Again, you can see the highlighted input data to help your team more quickly diagnose and troubleshoot vulnerabilities.

{{< figure src="17-webgoat-path-overview.png"  height="300px"
caption="[See the full-sized picture](17-webgoat-path-overview.png)"
>}}

---
### TeamServer: Path Traversal Vulnerability Details
The overview page summarizes the Path Traversal vulnerability similarly to previous examples in this workshop.
 
The essential detail on this page is the line about "Untrusted data used to open file" showing how the file reference is passed along to a file operation.  The flaw is created by the concatenations in the previous lines and shown here.

{{< figure src="17-webgoat-path-details.png"  height="300px"
caption="[See the full-sized picture](17-webgoat-path-details.png)"
>}}

---
### Additional Vulnerability Details

The Path Traversal vulnerability also have their corresponding pages to highlight these details:
- Details
- HTTP Info
- How to Fix
- Notes
- Discussion

You team can also use these resources and included links to help work through a solution for this flaw.

---
### Path Traversal Next Steps

You are encouraged to explore the subsection for Path Traversal to see the materials, the problems, and the solutions to this common Web Application Security Flaw.

The solution to this page highlights the payload you need to show files not in the list.  Security testers use these details and browser tools to send API calls in their testing.

Attackers use similar tools to find vulnerabilities to exploit. 

---
{{< slide id="contrast-protect" >}}
### Contrast Protect
In this part of the module, you will actively attack the software and observe how Contrast Protects your application.

---
### How to protect your application in production

Contrast Security not only shifts security left but also extends it to the right and protect running applications in productions from being exploited due to known or unknown vulnerabilities.

Contrast Security uses the same instrumentation agent to perform its inside-out analysis with Assess and runtime protection with Protect.

---
### WebGoat: SQL Injecting Data Entry
Let's revisit the String SQL Injection page.

In the previous example, we entered started text and Contrast Security alerted you to the vulnerability.

Here, we'll do an actual attack using the same page.

---
### Navigating to SQL Injections

In the subheadings on the left, expand the section entitled, "Injection Flaws."

Once expanded, click on the "String SQL Injection" option in the list." 

{{< figure src="14-webgoat-expand-injection.png" height="300px" text-align="center">}}
[See the full-sized picture](14-webgoat-expand-injection.png)

---
### Enter attack data
In the box to enter your last name, enter the SQL Injection text and press the "Go!" button.

```
Erwin' or '1'='1
```

The application will announce you correctly performed a SQL Injection because the text above adds an extra SQL clause.

Let's review in the next screens.

{{< figure src="14-webgoat-sql-injection.png" height="300px"
caption="[See the full-sized picture](14-webgoat-sql-injection.png)"
>}}

---
### TeamServer: Attack Notification

Navigate to Teamserver (https://eval.contrastsecurity.com/Contrast) with the credentials supplied to you.

You should see a new notification indicating your application is under attack and has been <B>Exploited</B>.

Let's investigate thie exploit and see how we can protect ourselves using Contrast Security.

{{< figure src="20-webgoat-injection-notification.png" height="300px" text-align="center">}}
[See the full-sized picture](20-webgoat-injection-notification.png)
 
---
### TeamServer: Sql Injection Attack - Overview

Your application Overview may have new details for libraries or routes.  Let's click into the "Attacks" subheading to see details for this attack.

{{< figure src="20-webgoat-injection-attack-overview.png" height="300px" text-align="center">}}
[See the full-sized picture](20-webgoat-injection-attack-overview.png)
 
---
### TeamServer: Attacks

Contrast Security will alert you to the exploit and give you mitigation options.  First, review the screen to see:

- The source IP
- The existing status, currently "Exploited"
- The rate at which the attack happened.
- The server
- The severity
- Protection options

{{< figure src="20-webgoat-injection-attack-attacks.png" height="300px">}}
[See the full-sized picture](20-webgoat-injection-attack-attacks.png)

---
### TeamServer Protection Options

The Protection options are identified by icons as shown in this picture

- Configure App Protection Rule
- Add Virtual Patch
- Blacklist IP

We'll review each.

{{< figure src="20-webgoat-injection-attack-protection.png" >}}

---
### TeamServer Policies
{{% note %}}
Explain the value of policies and how they are applied to your organization as a pattern.  This is a time-saving capability that allows your teams to enable consistent and systematic approaches to your company's software security strategy.

Contrast Security provides default (Best practices) policies for your team as a start.  This helps your teams more quickly onboard the solution to be Contrast Ready.

{{% /note %}}

As you can see, Contrast Security is already protecting the application from exploiting most common vulnerabilities.  

Contrast Security provides policies for different vulnerabilities you can set for each of your environments.  This matrix of options gives your team fined-grained control over the response for each of your applications.

The image below has some filtering enabled so we can focus on SQL Injection.  The workshop default is to monitor SQL Injection.

{{< figure src="20-webgoat-injection-protect-configure.png" height="300px">}}

We'll reconfigure the option next.

---
### Team Server Protection - Configure App Protection Rule - Part 2.

You should notice the SQL Injection policy is to MONITOR in the development environment.  

Clck on the Monitor option and change it setting from "Monitor" to "Block."

{{< figure src="20-webgoat-injection-protect-block.png" height="300px">}}

---
### Re-try SQL Exploit

Navigate back to your WebGoat application.

In the subheadings on the left, expand the section entitled, "Injection Flaws."

Once expanded, click on the "String SQL Injection" option in the list." 

{{< figure src="14-webgoat-expand-injection.png" height="300px" >}}
[See the full-sized picture](14-webgoat-expand-injection.png)

---
### Restart the lesson.

Click on the "Restart Lesson" button to reset the page.

{{< figure src="20-webgoat-injection-restart.png">}}

---
### Re-enter an exploit
Let's retry the SQL Injection again with a new value and press the "Go!" button.

```commandline
Smith' or '1'='1
```

{{< figure src="20-webgoat-injection-retry.png" height="300px" text-align="center">}}
[See the full-sized picture](20-webgoat-injection-retry.png)

---
### WebGoat with Protect Enabled

This time, you will see a different result on the webpage showing no results matched with an error.

This is an example of how Contrast Security protects running applications by *preventing* an attack from happening.

{{< figure src="20-webgoat-injection-block.png" height="300px" text-align="center">}}
[See the full-sized picture](20-webgoat-injection-block.png)

---
### SQL Injection Next Steps

The next two examples highlight other options as examples of what we suggest you test with your application or environment.

---
### Virtual Patches

Virtual patches are short-term, custom defense rules that protect against specific, newly discovered vulnerabilities in your code.

You have options to match by name, language, agent, and other factors 

See more information at: https://docs.contrastsecurity.com/en/virtual-patches.html 

{{< figure src="20-webgoat-protect-virtual-patch.png" height="300px" text-align="center">}}
[See the full-sized picture](20-webgoat-protect-virtual-patch.png)

---
### Blacklist IP

Alternatively, you can choose to block (or allow) specific IP addresses.  This is helpful when you wish to isolate traffic from specific ranges.

See more information at: https://docs.contrastsecurity.com/en/block-or-allow-ips.html

{{< figure src="20-webgoat-protect-ip-blacklist.png" height="300px" text-align="center">}}
[See the full-sized picture](20-webgoat-protect-ip-blacklist.png)

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
 
Go back to the [module list](../#/module-list)  
