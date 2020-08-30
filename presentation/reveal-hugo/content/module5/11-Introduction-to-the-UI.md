+++
title = "Introduction to the Contrast Security User Interface"
chapter = true
description = "Module 1 is about introducing the major values of using Contrast Security"
weight = 11
+++

{{% section %}}
## Introduction to TeamServer
There are several options to observe information about vulnerabilities in Contrast Security:

- The browser User Interface (UI)
- Programmatic/Command-Line (CLI) API access
- Via various integrations (Jira, Slack, IDEs, etc.)

In this workshop, we'll focus on the UI and CLI options.


---
{{% note %}}
The dashboard is a landing page for all Contrast Security users - developers, operations, security, and administrators.  The different dashboard pages provide a  
{{% /note %}}

## Log on to TeamServer
Start by logging onto the Contrast Security UI at https://eval.contrastsecurity.com with your supplied username and password.  

We'll use the default landing page's dashboard as the starting point for this module's exercise.  

{{< figure src="../images/04-dashboard.png#center" height="400px" text-align="center">}}
[See the full-sized picture](../images/04-dashboard.png)

---
{{% note %}}
In this slide, we should have already setup each user with their running applications so data has been sent to TeamServer.{{% /note %}}

## TeamServer Notification
Click on the bell icon in the upper right-hand corner to see notifications alerting us to the automatic onboarding of our new server and application.

{{< figure src="01-notifications-new-applications.png" height="400px" >}}
[See the full-sized picture](01-notifications-new-applications.png)

Your teams should expect an easy onboarding process especially if they regularly create and delete infrastructure and applications on demand.  This is especially true for teams as they shift to using cloud-based and ephemeral environments.  This automatic registration lets teams opt into a security model to the delight of your team members interested in security.

---
## TeamServer Dashboard
Back to the main dashboard, you should see a summary about your deployed applications:
- Number of Applications, Libraries and Servers
- Average time to remediate vulnerabilties
- Current vulnerabilities, listed by severity
- Current attacks

{{< figure src="../images/04-dashboard.png#center" height="400px" >}}
[See the full-sized picture](../images/04-dashboard.png)

---
## Real-Time Visibility
As you and your teams onboard applications, their results will be added to Contrast Security for better visibility into the state of your application development in real time.  This screenshot shows the dashboard after greater use with much more activity.

{{< figure src="m1-dashboard.png" height="400px" >}}
[See the full-sized picture](m1-dashboard.png)

---
## Ongoing Data Collection
From the onset, you accumulate results in TeamServer.  This is the first of many advantages of IAST, where your team's day-to-day exercising and testing automatically generates meaningful results of security vulnerabilities.  As you and your teams exercise more of your software, we'll keep track of new vulnerabilities and their remediation.

This means you can add Contrast Security to your existing workflow and start using results immediately.
There is high value to all members of your team when you can leverage this information with minimal configuration.

Next, we'll look through TeamServer to uncover new vulnerabilties.  Start by clicking into the Application heading:

{{< figure src="04-dashboard-command-bar-applications.png" >}}
[See the full-sized picture](04-dashboard-command-bar-applications.png)

---

Click into the name of your application, which contains "webgoat" and today's date.

{{< figure src="03-applications.png" >}}
[See the full-sized picture](03-applications.png)

---

Contrast Security starts by collecting information the moment your application is deployed.

{{< figure src="09-webgoat-overview.png" height="500px" >}}
[See the full-sized picture](09-webgoat-overview.png)

--- 
## Let's see the data we've already collected.
Now that your application is running, let's review the information we have already collected.  This includes the following topics covered in the next several screens:

- Overview
- Vulnerabilities
- Attacks
- Libraries
- Activity
- Route Coverage
- Flow Map
- Policy

---
{{< slide template="note" >}}
## The overview page

The next several slides are an overview of the TeamServer User Interface.  We'll walk you through each major page and describe what it brings to your team.

---
The overview pages
{{< figure src="09-webgoat-overview.png" style="border: 1px solid #000;" height="500px"
caption="[See the full-sized picture](09-webgoat-overview.png)"
>}}

---
The vulnerabilities page
{{< figure src="09-webgoat-vulnerabilities.png" height="500px"
caption="[See the full-sized picture](09-webgoat-vulnerabilities.png)"
>}}
---
The attacks page. We don't yet have any.
{{< figure src="09-webgoat-attacks-none.png"  height="500px"
caption="[See the full-sized picture](09-webgoat-attacks-none.png)"
>}}
---
The Libraries page.
{{< figure src="09-webgoat-libraries.png" height="500px"
caption="[See the full-sized picture](09-webgoat-libraries.png)"
>}}
---
The Route Coverage page, and why we have it.
{{< figure src="09-webgoat-route-coverage.png" 
height="500px" 
caption="[See the full-sized picture](09-webgoat-route-coverage.png)"
>}}
---
The Policy Page, and why we have it.
{{< figure src="09-webgoat-policy.png" height="500px"
caption="[See the full-sized picture](09-webgoat-policy.png)"
>}}
---

## Exploiting software
In the next section, we'll exploit the software for some known vulnerabilities.

{{% /section %}}
