+++
title = "Module 3: Building a DevOps Pipeline"
chapter = true
description = "The Contrast Security Workshop"
weight = 30
outputs = ["Reveal"]
draft = true

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

{{% section %}}
# Module 3: Building a DevOps Pipeline

---
## Introduction
In most organizations, development activity centers around a DevOps pipeline of checkout-build-test-deploy processes.  Frequently, this includes the deployment of software to more than one environment.

In the next several sections, we'll build a pipeline with these features that mirror typical DevOps teams:

- Build-and-deploy a Java application with Contrast Security
- Automated tests that publish results to TeamServer
- Jira and Slack updates as we find new vulnerabilities
- Deployments to multiple environments
- Remediation by fixing code and re-deploying running applications

---
{{< slide template="info" >}}
# Time and Prerequisites
This Module should take about 92 minutes to complete. 

Be sure to have completed the [prerequisites](../#/2)  

---
## Objectives

- Learn how to add Contrast Security to differents parts of your DevOps Pipeline
- See how to give your team fast feedback from Contrast Security
- Observe how improvements and fixes to your software are observed in Contrast Security


{{% /section %}}