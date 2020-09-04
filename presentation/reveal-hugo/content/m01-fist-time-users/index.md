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
- [LAB: Exploiting software](#/exploiting-software)
- [LAB: Libraries](#/libraries)
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

In this module we'll focus on the UI.

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

The time saved by automatically onboarding and offboarding applications is substantial.  No more complex rules, setup, or configuration.
{{% /note %}}

### TeamServer Notification
At the start of this workshop, your instructor deployed vulnerable applications for you.

Click on the bell icon in the upper right-hand corner to see notifications alerting us to the automatic onboarding of your new appplications and their servers.

{{< figure src="01-notifications-new-applications.png" height="400px" >}}
[See the full-sized picture](01-notifications-new-applications.png)

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
From the onset, you accumulate results in TeamServer.  Your team's day-to-day exercising and testing automatically generates meaningful results of security vulnerabilities.  

As you and your teams exercise more of your software, we'll keep track of new vulnerabilities and their remediation as soon as it is exercised.

There is high value to all members of your team when you can leverage this information with minimal configuration.

Click into the *Application* heading to see how TeamServer uncovers new vulnerabilities.

{{< figure src="04-dashboard-command-bar-applications.png" >}}
[See the full-sized picture](04-dashboard-command-bar-applications.png)

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
 
{{< figure src="09-webgoat-libraries.png" height="500px"
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

*see https://owasp.org/www-project-top-ten/OWASP_Top_Ten_2017/Top_10-2017_A1-Injection*

--- 
### Navigate to the application
{{% note %}}
Explain the nature of the WebGoat application, and some of the navigation options.

Logging in as guest or admin are acceptable, but we'll go with guest for this exercise. 
{{% /note %}}

Your instructor will give you application details in this format:

```text
yourname-java-webgoat-svc - http://52.149.201.3:18101/WebGoat
```

Navigate to your supplied URL and log on as the WebGoat *guest* presented on the login page. 

{{< figure src="14-webgoat-login.png" height="500px">}}

---
### Webgoat Main Page

Webgoat is a collection of open-sourced collection of Security exercises and examples for security professionals to review.

The home page of the Webgoat application shows you the following:
- Main topics on the left
- Content in the middle

{{< figure src="14-webgoat-mainpage.png" height="400px" text-align="center">}}
[See the full-sized picture](14-webgoat-mainpage.png)

---
### LAB: Navigating to SQL Injections

Expand the section entitled, "Injection Flaws" on the left to see our options.

Once expanded, click on the "String SQL Injection" option in the list. 

{{< figure src="14-webgoat-expand-injection.png" height="400px" text-align="center">}}
[See the full-sized picture](14-webgoat-expand-injection.png)

---
### WebGoat: Expose a SQL Injection Vulnerability
The String SQL Injection page is an example of the content in WebGoat.  A blend of instruction, data-entry, and challenge.

 Here, we'll enter a name in a standard text field as part of the exercise.  Please enter your name or "Smith" as the example suggests.

You will see a response indicating, "No results matched."

This is typical data-entry and not a test for exploits.  Normal scanning and user testing usually doesn't reveal there is a security vulnerability on this page.  

Let's examine the results from Contrast Security.

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

You should see a new notification indicating your application has a new critical vulnerability.  

{{< figure src="14-webgoat-injection-notification.png" height="400px" text-align="center">}}

This first-time type of notification is useful when first onboarding an application or first uncovering a vulnerability.

Click on "Critical vulnerability" to navigate directly to the newly found vulnerability.

Alternatively, click on the name of the application and navigate to the subheading "Vulnerabilities" and then into the newly discovered Critical Vulnerability.
 
---
### TeamServer: Vulnerability Details
Clicking into the Critical vulnerability gives you an overview page summarizing the vulnerability with the name, and details on how it was detected.  This is good context for teams when they review. 

{{< figure src="09-webgoat-sql-injection-overview.png"  height="500px"
caption="[See the full-sized picture](09-webgoat-sql-injection-overview.png)"
>}}

This example showcases one of the many strengths of Contrast Security.  The ordinary operation of entering a last name reveals to the tester there is a real vulnerability within the code.

---
### Additional Vulnerability Details

Next, let's review the details for these sections:
- Details
- HTTP Info
- How to Fix
- Notes
- Discussion

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
{{< slide id="contrast-protect" >}}
### Contrast Protect
In this part of the module, you will actively attack the software and observe how Contrast Protects your application.

---
### A second vulnerability

XSS example - TBD


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
 
Go back to the [module list](../#/module-list)  
