+++
title = "Module 4: Building a DevOps Pipeline"
chapter = true
description = "The Contrast Security Workshop"
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

You should be ready to explain the pipeline stages Development, Test, and Release correspond to the environments named DEV/QA/PROD.

{{% /note %}}
# Module 4: Building a DevOps Pipeline

Jump to:
- [Module Introduction](#/module-introduction)
- [Objectives](#/objectives)
- [LAB:Build-and-Deploy attempt #1](#/lab-build-and-deploy-1)
    - [Detect and remediate DEV vulnerability](#/lab-detect-and-remediate-1)
- [LAB:Build-and-Deploy attempt #2](#/lab-build-and-deploy-2)
    - [Detect and remediate QA vulnerability](#/lab-detect-and-remediate-2)
- [LAB:Build-and-Deploy attempt #3](#/lab-build-and-deploy-3)
    - [Observe Protect Attack](#/lab-observe-protect-attack)
- [Conclusion](#/conclusion)

---
{{< slide id="module-introduction" >}}
## Introduction
In most organizations, development activity centers around a DevOps pipeline of checkout-build-test-deploy processes, including  deploying software to multiple environments.

In this module, we'll mirror a typical DevOps pipeline with these features:

- Build-and-deploy a Java application with Contrast Security
- Deploy to three environments representing DEV/QA/PROD
- Identify vulnerabilities to fail the pipeline 
- Remediate vulnerabilities and restart the pipeline

---
{{< slide template="info" >}}
# Time and Prerequisites
This Module should take about 90 minutes to complete. 

Be sure to have completed the [prerequisites](../#/2)  

---
{{< slide id="objectives" >}}
## Objectives

- Learn how to add Contrast Security to your DevOps Pipeline
- See how to give your team fast feedback from Contrast Security
- Observe how improvements and fixes to your software are observed in Contrast Security

---
{{< slide id="lab-build-and-deploy-1" >}}
## LAB: Checkout and build

We will start by having you checkout the code locally, and then we'll build on an already running Jenkins Server configured with a build pipeline.

---
### Checking out the code

Check out the code onto your local workstation, so you can better investigate the content of the files.

Open a command prompt and run this command:

```commandline
cd %HOMEPATH%
git clone https://github.com/Contrast-Security-OSS/workshop
git clone <TODO: IDENTIFY A MODULE WHERE WE CAN SHOW RBAV>

```

---
## The Contrast Security workshop project

The `Contrast-Security-OSS/workshop` repository contains the contents of this workshop, plus helper scripts and tools to speed things along.
  
We encourage you to browse through this open-source repository to review other modules and examples.


---
### Review and study the directory structure

Navigate through the folder to observe the characteristics of this project:
- Build script
- Jenkinsfile
- Source Code
- Tests

---
### Review the Jenkinsfile

Study the Jenkinsfile for is content:
- Overall layout of the pipeline stages
- The build step
- Adding our instrumentation
- Deploying the file to an environment
- Testing the environment

_These are all steps that map to conventional DevOps pipelines._

---
### Navigate to Jenkins

Your instructor has configured a username and password on a Jenkins server, plus a working pipeline for this workshop.

Navigate to the Jenkins URL and log on with the credentials supplied to you by your instructor.

TODO: Include a screenshot of the Jenkins server logon.

---
### Navigate to your Jenkins project

Click through the Jenkins configurations to find the Contrast Security Workshop folder for this exercise, and then the configuration with your name

`TODO: Include a screenshot of the Jenkins workshop folder`

`TODO: Include a screenshot of the Jenkins project for a user`

---
### Review the contents of your pipeline

The repository file named `Jenkinsfile` contains your pipeline definition.  If we examine the contents of this file, you will see the following organizational layout:

- pipeline
  - stages
    - stage
        - step

Your instructor will walk you through the major elements that map over to common DevOps pipelines.

Special attention will be placed on the features to include Contrast Security.

---
### Adding the Contrast Security agent

Other modules describe the process of adding an agent to an application in detail.

Here, let's identify the lines in the build definition that add the agent in the build, and how we use it in tests.

`TODO: Add a screenshot of the pipeline step.`

---
### Enabling Contrast Security Build Failures

Contrast Security let's you define failure thresholds for a build.  This means if your build does not meet the required levels, the build will fail until your team can fix the vulnerability.

Here, we will set the threshold in our Jenkins Plugin.

`TODO: Add a screenshot where we show this configurable item`

See also https://plugins.jenkins.io/contrast-continuous-application-security/.

---
### Run the pipeline to see the build

We're ready to trigger our build pipeline.  Run the build with the details as shown below:

`TODO: Add a screenshot`

`TODO: Identify required running parameters`

Let's investigate this first end-to-end pipeline run and observe the pipeline failure in the Development Stage corresponding to the environment named DEV.

---
{{< slide id="lab-detect-and-remediate-1" >}}
### Testing - vulnerability #1

We will expose our first vulnerability when we run the pipeline and its automated tests.

The result is a failure in Jenkins.

`TODO: Show a Jenkins screenshot with the build failure`

Next, let's look at TeamServer

---
### TeamServer Vulnerability #1

Next, navigate to TeamServer at https://eval.contrastsecurity.com/Contrast, and then find your vulnerable application.

Work with your instructor to review the contents of the vulnerabilities, messages, and steps to mitigate.

`TODO: Show a screenshot of TeamServer and the vulnerability for DEV`

---
### Fix the code for DEV

Let's fix the code for the vulnerability we just found.

We'll walk through the code change by using a fix already checked into a different branch.

At the command line, run this command

```commandline
cd %HOMEPATH%
git checkout <name of the first branch>
```

`TODO: identify the branch with the code fix`

---
### Examine the DEV code difference

On GitHub, navigate to this page to see the code difference with the changes for this vulnerability.

`TODO: Include a link to the branch's code difference highlighting the code change`

---
### Reconfigure Jenkins

{{% note %}}
Instructors: Show the users how this is the only change in the branch.
{{% /note %}}

On the Jenkins server, reconfigure the pipeline to use the new branch named `TODO: The name of the new branch."

`TODO: Add a screenshot showing how to reconfigure the Jenkins Server`

---
{{< slide id="lab-build-and-deploy-2" >}}
## LAB: Run the pipeline a second time

Re-Run the build with the details as shown below:

`TODO: Identify required running parameters`

Let's investigate this second end-to-end pipeline run, which will fail on the TEST stage.

---
{{< slide id="lab-detect-and-remediate-2" >}}
### Testing - vulnerability #2

We will expose our second vulnerability when we run the pipeline and its automated tests.  In higher environments, DevOps teams reveal issues not always visible in lower environments.  Here, we expose a vulnerability in the QA environment  

The result is a failure in Jenkins.

`TODO: Show a Jenkins screenshot with the build failure`

Let's review this failure on TeamServer

---
### Review Vulnerability #1

Next, navigate to TeamServer at https://eval.contrastsecurity.com/Contrast, and then find your vulnerable application in the DEV Environment.

Your instructor will show you the remediation of the first vulnerability.

`TODO: Show a screenshot of TeamServer and the remediated vulnerability in DEV`

`TODO: Work through a RBAV example.`

---
### TeamServer Vulnerability #2

Navigate to TeamServer at https://eval.contrastsecurity.com/Contrast, and then find your vulnerable application for the QA Environment.

Work with your instructor to review the contents of the vulnerabilities, messages, and steps to mitigate.

`TODO: Show a screenshot of TeamServer and the vulnerability for QA`

---
### Fix the code for TEST

Let's fix the code for the vulnerability we just found.

We'll walk through the code change by using a fix already checked into a different branch.

At the command line, run this command

```commandline
cd %HOMEPATH%
git checkout <name of the second branch>
```

`TODO: identify the second branch with the code fix for QA`

---
### Examine the TEST code difference

On GitHub, navigate to this page to see the code difference with the changes for this vulnerability.

`TODO: Include a link to the branch's code difference highlighting the code change`

---
### Reconfigure Jenkins

{{% note %}}
Instructors: Show the users how this is the only change in the branch.
{{% /note %}}

On the Jenkins server, reconfigure the pipeline to use the new branch named `TODO: The name of the new branch."

`TODO: Add a screenshot showing how to reconfigure the Jenkins Server`

---
{{< slide id="lab-build-and-deploy-3" >}}
## LAB: Run the pipeline a third time

Re-Run the build with the details as shown below:

`TODO: Identify required running parameters`

Let's investigate this third end-to-end pipeline run, which will successfully run all the way through the RELEASE stage and deploy software to the PROD environment.

---
### Review Vulnerability #2

Next, navigate to TeamServer at https://eval.contrastsecurity.com/Contrast, and then find your vulnerable application in the QA Environment.

Your instructor will show you the remediation of the first vulnerability.

`TODO: Show a screenshot of TeamServer and the remediated vulnerability in DEV`

`TODO: Work through a RBAV example.`

---
{{< slide id="lab-observe-protect-attack" >}}
## Contrast Protect

Given the running application, work through an example of Protect

---
{{< slide id="conclusion" >}}
## Conclusion
This concludes the module.
Your instructor will inform you about how long your environment will remain in operation and if you will be covering other modules.

Go back to the [module list](../#/module-list)  
