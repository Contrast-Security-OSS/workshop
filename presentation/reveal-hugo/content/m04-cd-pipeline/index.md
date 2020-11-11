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
DevOps/DevSecOps teams use automated pipelines to organize their software checkout-build-test-deploy processes.  These pipelines provide  reliable and predictable results to the entire team, and Contrast Security is designed to work in these high-velocity pipelines.

In this workshop module, we'll mirror a typical DevOps pipeline with these features:

- Build-and-deploy a Java application with Contrast Security
- Run automated tests locally, representing DEV processes
- Run tests remotely, representing QA processes
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
Since we use shared resources to perform the same operations, we'll use a simplified pipeline to imitate conventional operations in this workshop.  Modern DevOps teams utilize techniques that are not practical in a workshop environment.

In this module, we'll avoid some tasks such as:
 
- Checking in code
- Managing Pull requests
- Creating tickets

A benefit of using a simplified pipeline is we can place focus on tasks centered around Contrast Security.

---
### Navigate to Jenkins

Your instructor has configured a username and password on a Jenkins server, plus a working pipeline for this workshop.

Navigate to the Jenkins URL and log on with the credentials supplied to you by your instructor.

{{< figure src="05-jenkins-logon.png" style="border: 1px solid #000;">}}

---
### Navigate to your Jenkins folder

Click through the Jenkins configurations to find the folder with your name for this exercise:

{{< figure src="05-jenkins-myfolder.png" style="border: 1px solid #000;">}}

---
### Navigate to your Jenkins project

Click into your project entitled, *spring-petclinic.*

{{< figure src="05-jenkins-my-spring-petclinic.png" style="border: 1px solid #000;">}}

---
{{< slide id="fist-run" >}}
### First run

Start by triggering an initial build of your pipeline.  This initial pipeline is a skeleton model of a DevOps pipeline.  
{{< figure src="05-jenkins-trigger-first-build.png" style="border: 1px solid #000;">}}

---
### First run results

Let's review the results of this first run to see the pipeline stages and their intended activities.
- DEV/QA/UAT/PRE-PROD/PROD/OPERATE
- These stages imitate advanced enterprise pipelines 

{{< figure src="05-jenkins-first-run-results.png" height="300px">}}
[See the full-sized picture](05-jenkins-first-run-results.png)

---
### View the configuration

Click into the *Configure* link to examine the organization of the pipeline, and its three main sections

- Parameters
- Github Project
- Pipeline Script

---
### Review the parameterized section

The parameterized section contains details specific to your identity.  

The details are your User Settings keys to access the Contrast TeamServer via API.   

{{< figure src="05-jenkins-configuration-parameters.png" height="300px">}}
[See the full-sized picture](05-jenkins-configuration-parameters.png)

---
### Add your `contrast_security.yaml` credentials parameter

Your instructor already added a `contrast_security.yaml` file with your name, which we use below.

{{< figure src="05-jenkins-configuration-add-parameter.png">}}

- Navigate to the subsection at *General->This project is parameterized.*
- Click on the button to *Add Parameter* of type *Credentials Parameter*.
- Name your credential as: `contrast_security`
- Select the Credential type as `secret file`
- Assign the default value as `contrast_security-<yourname>.yaml` where the file has your name.

---
### Credentials parameter - results

The results of your added credential should look similar to the following:

{{< figure src="05-jenkins-configuration-add-credentials-parameter.png">}}

As you can see, the parameter named `contrast_security.yaml` refers to your file, which we'll use in later steps

---
### Review Jenkins Pipeline definition

The Pipeline section contains an in-line definition of your pipeline.  In the coming sections, we'll spend most of our time adding code to the pipeline definition to include Contrast Security capabilities.  These sections are marked with comments.

{{< figure src="05-jenkins-configuration-pipeline.png" height="300px">}}
[See the full-sized picture](05-jenkins-configuration-pipeline.png)

---
### Add the Github Project reference

In your Jenkins Configuration, under the Pipeline section entitled, _Pipeline script_, find the line with this text:

```groovy
//                ### TODO INSERT clone operation on next line
```
The pipeline points to the source code in a GitHub branch with a known vulnerability.  Uncomment the line that starts with `git branch.`

```groovy
        stage("DEV") {
            steps {
                sh 'echo "DEV"'
                sh 'echo "checkout"'
//                ### TODO INSERT clone operation on next line
                git branch: '1.5.4-SQLi', url: 'https://github.com/Contrast-Security-OSS/spring-petclinic.git'
```

---
### Acquire your yaml file

In your Jenkins Configuration, under the Pipeline section entitled, _Pipeline script_, find the line with this text:

```groovy
### TODO INSERT credentials block on next line
```

Uncomment the code below the instructions as shown below.

```groovy
//                  ### TODO INSERT credentials block on next line
                script {
                    withCredentials([file(credentialsId: 'contrast_security.yaml', variable: 'yaml')]) {
                        def contents = readFile(env.yaml)
                        writeFile file: 'contrast_security.yaml', text: "$contents"
                    }
                    sh 'cat contrast_security.yaml'
                }
```

This script gets the contents of the secret and writes it as a file of the same name.
Save your changes and trigger the build to verify the results.

---
{{< slide template="tip" >}}
### TIP

There is more than one way to acquire the `contrast_security.yaml` file.  We prescribe a simple model given workshop requirements and limitations.

More advanced teams may utilize techniques aligned with local security-minded policies.  This includes parsing the yaml file or using environment variables.  Those techniques are beyond the scope of this workshop. 

---
{{< slide template="tip" >}}
### TIP
Many teams settle on using infrastructure-as-code (IaC) to check-in their pipeline definition into a repository.  On Jenkins, this means capturing the defintion into a Jenkinsfile.  We will edit a pipeline definition maintained in Jenkins instead.  It is common for teams to prototype in-line, and then commit their working changes to a Jenkinsfile.

We will not re-define the Jenkinsfile because it is common for the whole class.

---
### Run the pipeline to see the build

We're ready to trigger our build pipeline.  Run the build with the details as shown below:

{{< figure src="05-jenkins-jenkinsfile-01-run.png">}}

Examine the console output for additional details.

---
### Review the log

Navigate into the log files to see the outcomes of the following:
- Java and Maven versions
- The contents of your contrast_security.yaml file
- The clone operation

Next, we'll add a command to build the code and run unit tests, and observe our first failure.

---
Enable the first build

Navigate to your pipeline definition and find the line with this text:

```groovy
//                  ### TODO use the contents of the YAML file below.
```

Uncomment the build code so the block looks like this:

```groovy
//                  ### TODO use the contents of the YAML file below.
                script {
                    // We're usinmg https://plugins.jenkins.io/build-user-vars-plugin/
                    wrap($class: 'BuildUser') {
                        def yaml = readYaml file: 'contrast_security.yaml'
                        echo "api_key ${yaml.api.api_key}"
                        echo "username ${yaml.api.user_name}"
                        echo "apiUrl ${yaml.api.url}"
                        echo "service key ${yaml.api.service_key}"
                        echo "org UUID ${params.orguuid}"
                        sh 'echo "build"'
                        echo "firstname ${BUILD_USER_FIRST_NAME}"
                        echo "lastname ${BUILD_USER_LAST_NAME}"
                        echo "user ${BUILD_USER}"
                        echo "email ${BUILD_USER_EMAIL}"
                        sh """
                        ### TODO INSERT EXPORT commands on next lines
                        export CONTRAST__API__URL="${yaml.api.url}"
                        export CONTRAST__API__API_KEY="${yaml.api.api_key}"
                        export CONTRAST__API__SERVICE_KEY="${yaml.api.service_key}"
                        export CONTRAST__API__USER_NAME="${yaml.api.user_name}"
                        env
                        mvn --version
                        ### TODO INSERT maven commands on next line
                        echo mvn -P contrast-maven  -Dcontrast-login-username="${BUILD_USER_EMAIL}" -Dcontrast-apiKey=${yaml.api.api_key} -Dcontrast-serviceKey=${params.service_key} -Dcontrast-apiUrl="http://host.docker.internal:28080/Contrast/api" -Dcontrast-orgUuid=${params.orguuid} -Dcontrast-first-name=${BUILD_USER_FIRST_NAME} -Dcontrast-hostname=${BUILD_USER}-server clean  verify
                        ### TODO UNCOMMENT TO ENABLE THE BUILD
                        ##mvn -P contrast-maven  -Dcontrast-login-username="${BUILD_USER_EMAIL}" -Dcontrast-apiKey=${yaml.api.api_key} -Dcontrast-serviceKey=${params.service_key} -Dcontrast-apiUrl="http://host.docker.internal:28080/Contrast/api" -Dcontrast-orgUuid=${params.orguuid} -Dcontrast-first-name=${BUILD_USER_FIRST_NAME} -Dcontrast-hostname="${BUILD_USER}-server" clean  verify
                        """
                    }
```

Save the configuration and Build with Parameters to create a new build. 

---
### Review your build

Review the console output to verify you have these details:

- The contents of the echo commands reveal your key, and user identity.
- The echo of the maven command matches what your instructor describes

The echo should produce something that resembles the folowing:

```
mvn -P contrast-maven -Dcontrast-login-username=mr.marco.a.morales@gmail.com -Dcontrast-apiKey=YOUR_API_KEY -Dcontrast-serviceKey=YOUR_SERVICE_KEY -Dcontrast-apiUrl=http://host.docker.internal:28080/Contrast/api -Dcontrast-orgUuid=YOUR_ORG_ID -Dcontrast-first-name=Marco -Dcontrast-hostname=Marco Morales-server clean verify
```

---
### Enable the build

Once the maven echo line looks good, enable the pipeline script to build the project by uncommenting this line:

```shell script
                        ### TODO INSERT maven commands on next line
                        echo mvn -P contrast-maven  -Dcontrast-login-username="${BUILD_USER_EMAIL}" -Dcontrast-apiKey=${yaml.api.api_key} -Dcontrast-serviceKey=${params.service_key} -Dcontrast-apiUrl="http://host.docker.internal:28080/Contrast/api" -Dcontrast-orgUuid=${params.orguuid} -Dcontrast-first-name=${BUILD_USER_FIRST_NAME} -Dcontrast-hostname=${BUILD_USER}-server clean  verify
                        ### TODO UNCOMMENT TO ENABLE THE BUILD
                        mvn -P contrast-maven  -Dcontrast-login-username="${BUILD_USER_EMAIL}" -Dcontrast-apiKey=${yaml.api.api_key} -Dcontrast-serviceKey=${params.service_key} -Dcontrast-apiUrl="http://host.docker.internal:28080/Contrast/api" -Dcontrast-orgUuid=${params.orguuid} -Dcontrast-first-name=${BUILD_USER_FIRST_NAME} -Dcontrast-hostname="${BUILD_USER}-server" clean  verify

```

Save your definition and run your Jenkins pipeline.

---
{{< slide id="lab-detect-and-remediate-1" >}}
### Testing - vulnerability #1

We will expose our first vulnerability when we run the pipeline and its automated tests.

The result is a failure in Jenkins.

`TODO: Show a Jenkins screenshot with the build failure`

Next, let's look at TeamServer

---
### Jenkins output

```
[INFO] 
[INFO] --- maven-jar-plugin:2.6:jar (default-jar) @ spring-petclinic ---
[INFO] Building jar: /var/lib/jenkins/workspace/spring-petclinic/jenkinsfile-02/target/spring-petclinic-1.5.4.jar
[INFO] 
[INFO] --- contrast-maven-plugin:2.8:verify (verify-with-contrast) @ spring-petclinic ---
[INFO] Successfully authenticated to TeamServer.
[INFO] Checking for new vulnerabilities for appVersion [petclinic-20201111194959]
[INFO] Sending vulnerability request to TeamServer.
[INFO] 1 new vulnerability(s) were found.
[INFO] Trace: Hibernate Injection from "lastName" Parameter on "/owners" page
Trace Uuid: 6DZK-HPTB-UAXJ-YAJP
Trace Severity: Critical
Trace Likelihood: High
```
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
## The Contrast Security workshop project

The `Contrast-Security-OSS/workshop` repository contains the contents of this workshop, plus helper scripts and tools to speed things along.
  
We encourage you to browse through this open-source repository to review the contents of the build scripts and source code.  We will not use the code directly, and do not need to check it out.

This repository is available at: https://github.com/Contrast-Security-OSS/spring-petclinic

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

