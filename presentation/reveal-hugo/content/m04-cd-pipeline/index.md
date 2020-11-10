+++
title = "Module 4: Building a DevOps Pipeline"
chapter = true
description = "The Contrast Security Workshop"
outputs = ["Reveal"]
layout = "bundle"
draft = false

[logo]
src = "../images/contrast-security-gray-logo.png"
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
- [LAB:First-time-build](#/first-run)
- [LAB:Add code](#/add-code)
- [LAB:Build code for the first time](#/first-time-build)
- [Conclusion](#/conclusion)

---
{{< slide id="module-introduction" >}}
## Introduction
{{% note %}}
Instructors: Let's use DevOps as the term for both DevOps and DevSecOps teams to convey unity and to help establish that security needs to be part of every DevOps team.
{{% /note %}}
In most organizations, development activity centers around a DevOps/DevSecOps Pipeline of checkout-build-test-deploy processes, including  deploying software to multiple environments.

In this module, we'll mirror a typical DevOps pipeline with these features:

- Build-and-deploy a Java application with Contrast Security
- Deploy to more than one environment representing DEV/QA/PROD
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
{{< slide template="warning" >}}
# DevOps Pipelines
Modern DevOps teams utilize features that are not practical for this workshop, given the need to work with the same example across multiple people at the same time:
 
- Checking in code
- Managing Pull requests
- Deploying to production environments

This workshop uses a simplified pipeline to imitate conventional operations.  

The simplified pipeline in this workshop illustrates the essential behaviors your DevOps teams use.

---
## The Contrast Security workshop project

The `Contrast-Security-OSS/workshop` repository contains the contents of this workshop, plus helper scripts and tools to speed things along.
  
We encourage you to browse through this open-source repository to review other modules and examples.

---
## The spring-petclinc project

The `Contrast-Security-OSS/spring-petclinic` repository contains source code for a vulnerable java application we will add to a pipeline.

We encourage you to browse through this open-source repository to review other modules and examples.

---
### Navigate to Jenkins

Your instructor has configured a username and password on a Jenkins server, plus a working pipeline for this workshop.

Navigate to the Jenkins URL and log on with the credentials supplied to you by your instructor.

TODO: Include a screenshot of the Jenkins server logon.

---
### Navigate to your Jenkins project

Click through the Jenkins configurations to find the your folder for this exercise

`TODO: Include a screenshot of the Jenkins workshop folder`

`TODO: Include a screenshot of the Jenkins project for a user`

---
{{< slide id="fist-run" >}}
### First run

Start by initiating your running the build once to register our first success.


---
### View the configuration

Students start with a skeleton pipeline we'll explore and identify where we'll fill in details.

---
### Review the parameterized section

The parameterized section contains details that will be specific to your running builds, or "personality." 

---
### Add a parameter for your contrast_security.yaml file
Your instructor has configured the system with a credential with your name in this format:
`contrast_security.yaml-<yourname>`

Let's add your file as a parameter.  Start by navigating to the subsection at *General->This project is parameterized.*
Click on the button to *Add Parameter* of type *Credentials Parameter*.

`TODO: Add a screenshot of the UI here, showing the initial section.`

---
### Add Secret File Credential

*Name* your credential "contrast_security" and set its *Credential type* as "Secret file."  

We'll refer to the name `contrast_security` in later steps.
 
For the *Default Value,* select the contrast_security yaml file with your name.

`TODO: Add a screenshot of the UI here, showing sample values.` 

---
### Acquire your yaml file

In your Jenkins Configuration, under the Pipeline section entitled, _Pipeline script_, find the line with this text:

```
### ADD YAML DOWNLOAD HERE
```

Copy the code below immediately after the line above.

```groovy
    script {
        withCredentials([file(credentialsId: 'contrast_security', variable: 'yaml')]) {
            def contents = readFile(env.yaml)
            writeFile file: 'contrast_security.yaml', text: "$contents"
        }
        sh 'cat contrast_security.yaml'
    }
```

This script gets the contents of the secret and writes it as a file.

---
{{< slide template="tip" >}}
### TIP

There is more than one way to acquire the `contrast_security.yaml` file.  We prescribe a simple model of getting the file and writing it to disk in a way that scales for our multiple classes and users.

Your instructor uploaded your file before this class to save time.

More advanced teams may utilize techniques aligned with local security policies.  This may include parsing the yaml file or using environment variables.  Those techniques are beyond the scope of this workshop. 

---
### Review the Github Project reference

The pipeline points to the source code at a specific location.

We're working from a specific branch, with a known vulnerability in it.

Navigate to the project to see the folder structure and contents of this maven-based java build to see the section where we check clone a project from GitHub.

```groovy
    stages {
        stage("DEV") {
            steps {
                sh 'echo "build"'
                git branch: '1.5.4-SQLi', url: 'https://github.com/Contrast-Security-OSS/spring-petclinic.git'
```

---
{{< slide template="tip" >}}
### TIP
Many teams settle on using infrastructure-as-code (IaC) to check-in their pipeline definition into a repository.  On Jenkins, this means capturing the defintion into a Jenkinsfile.  We will edit a pipeline definition maintained in Jenkins instead.  It is common for teams to prototype in-line, and then commit their working changes to a Jenkinsfile.

We will not re-define the Jenkinsfile because it is common for the whole class.

---
### Run the pipeline to see the build

We're ready to trigger our build pipeline.  Run the build with the details as shown below:

`TODO: Add a screenshot`

Let's investigate this first end-to-end pipeline run and observe the pipeline failure in the Development Stage corresponding to the environment named DEV.

---
### Review the log

Navigate into the log files to see the outcomes of the following:
- Java and Maven versions
- The contents of your contrast_security.yaml file
- The clone operation

Next, we'll add a command to build the code and run unit tests.

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
### Review the Jenkinsfile

Study the Jenkinsfile for is content:
- Overall layout of the pipeline stages
- The build step
- Adding our instrumentation
- Deploying the file to an environment
- Testing the environment

_These are all steps that map to conventional DevOps pipelines._

---
{{< slide id="conclusion" >}}
## Conclusion
This concludes the module.
Your instructor will inform you about how long your environment will remain in operation and if you will be covering other modules.

Go back to the [module list](../#/module-list)  

---
## LAB: Checkout and build

We will start by having you checkout the code locally, and then we'll build on an already running Jenkins Server configured for your build pipeline.

---
### Checking out the code

Let's start by checking out code onto your local workstation, so you can better investigate the content of the files.

Open a command prompt and run this command:

```commandline
cd %HOMEPATH%
git clone https://github.com/Contrast-Security-OSS/workshop
git clone https://github.com/Contrast-Security-OSS/spring-petclinic

```

---
### Review and study the directory structure

Navigate through the folder to observe the characteristics of this project:
- Build script
- Maven pom.xml file
- Source Code
- Tests

