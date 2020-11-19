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
- [LAB: Using Jenkins](#/using-jenkins)
- [First-run](#/first-run)
- [LAB: Adding Contrast Security to your Pipeline](#/add-contrast-to-your-pipeline)
- [LAB: Add a Build with Automated Tests](#/add-build-with-tests)
- [LAB: Deploy the software application](#/deploy-the-application)
- [Final Review](#/final-review)
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

Here, we'll avoid some tasks such as:
 
- Checking in code
- Pull Requests
- Creating tickets

A benefit of using a simplified pipeline is we can place focus on tasks centered around Contrast Security.

---
{{< slide id="using-jenkins" >}}
## LAB: Using Jenkins

Your instructor has configured a username and password on a Jenkins server, plus a working pipeline for this workshop.

Navigate to the Jenkins URL and log on with the credentials supplied to you by your instructor.

{{< figure src="05-jenkins-logon.png" style="border: 1px solid #000;">}}

---
### Navigate to your Jenkins folder

Click through the Jenkins configurations to find the Workshop folder and then the sub-folder with your name for this exercise:

{{< figure src="05-jenkins-myfolder.png" style="border: 1px solid #000;">}}

---
### Navigate to your Jenkins project

Click into your project entitled, *spring-petclinic.*

{{< figure src="05-jenkins-my-spring-petclinic.png" style="border: 1px solid #000;">}}

---
{{< slide id="first-run" >}}
### First run
{{% note %}}
This is jenkinsfile-00
{{% /note %}}

Start by triggering an initial build of your pipeline.  This initial pipeline is a skeleton model of a DevOps pipeline.  
{{< figure src="05-jenkins-trigger-first-build.png" style="border: 1px solid #000;">}}

Reference: `jenkinsfile-00`

---
### First run results

Review the results of this first run to see the pipeline stages and their intended activities.
- DEV/QA/UAT/PRE-PROD/PROD/OPERATE
- The intent is to emulate a multi-environment enterprise pipeline
- We will focus on the first three stages where Contrast Security is used two different ways

{{< figure src="05-jenkins-first-run-results.png" height="300px">}}
[See the full-sized picture](05-jenkins-first-run-results.png)

---
{{< slide id="add-contrast-to-your-pipeline" >}}
## LAB: Adding Contrast Security to your Pipeline
Next we'll add support for using Contrast Security

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
{{< slide template="tip" >}}
### The contrast_security.yaml file.

The file `contrast_security.yaml` contains keys to enable your instrumented application to communicate with the Contrast TeamServer.  You have more than one way to supply keys to your application, including the yaml file, environment variables, or command-line options. 

This workshop imports `contrast_security.yaml` as a secret file into Jenkins for use in a pipeline.  We cover other options in separate workshop modules.

More advanced teams may utilize techniques aligned with local security-minded policies.  This includes parsing the yaml file or using environment variables.  Those techniques are beyond the scope of this workshop. 

---
### Add your `contrast_security.yaml` credentials parameter

Your instructor added a `contrast_security.yaml` file with your name to the Jenkins instance.  We'll add this credential as a Jenkins Credentials Parameter.

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

As you can see, the parameter named `contrast_security.yaml` refers to your file, which we'll use in later steps.


---
### Review Jenkins Pipeline definition

The Pipeline section contains an in-line definition of your pipeline.  In the coming sections, we'll spend most of our time editing the content to include Contrast Security capabilities.  These sections are marked with comments.

{{< figure src="05-jenkins-configuration-pipeline.png" height="300px">}}
[See the full-sized picture](05-jenkins-configuration-pipeline.png)

---
### Add the Github Project reference

In your Jenkins Configuration, under the Pipeline section entitled, _Pipeline script_, find the line with this text:

```groovy
//                ### TODO INSERT clone operation on next line
```
The pipeline points to a branch with a known vulnerability.  Uncomment the line that starts with `git branch` for the branch named `1.5.4-SQLi`:

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
Save your changes.

---
{{< slide template="tip" >}}
### TIP
Many teams use infrastructure-as-code (IaC) techniques and check-in their pipeline definition into a repository.  On Jenkins, this means capturing the defintion into a Jenkinsfile and storing it on a GitHub repository.  

We will edit a definition stored in Jenkins.  It is common for teams to prototype an in-line defintion and then commit their working changes to a Jenkinsfile.

We are not checking-in a revised Jenkinsfile because it is shared with the entire class.

---
### Run the pipeline to see the build
{{% note %}}
This is jenkinsfile-01
{{% /note %}}

We're ready to trigger our build pipeline.  Run the build with the details as shown below:

{{< figure src="05-jenkins-jenkinsfile-01-run.png">}}

Examine the console output for additional details.

Reference: `jenkinsfile-01`

---
### Review the log

Navigate into the log files to see the outcomes of the following:
- Java and Maven versions
- The contents of your contrast_security.yaml file
- The clone operation

Next, we'll add a command to build the code and run unit tests, and observe our first failure.

---
{{< slide id="add-build-with-tests" >}}
## LAB: Add a Build with Automated Tests
{{% note %}}
This is jenkinsfile-02
{{% /note %}}

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

Save the configuration.  Next Build with Parameters to create a new build.

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

Reference: `jenkinsfile-02`

---
{{< slide id="lab-detect-and-remediate-1" >}}
### Hibernate Injection Vulnerability

We expose a vulnerability when we run the pipeline and its automated tests, and the result is a failure in Jenkins.

{{< figure src="05-jenkins-dev-build-failure.png" style="border: 1px solid #000;">}}

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

Let's review on TeamServer

---
### TeamServer Logon

Next, navigate to TeamServer at https://eval.contrastsecurity.com/Contrast, and then find your vulnerable application.

Your instructor will review the results of the tests and show you vulnerabilities, messages, and steps to mitigate.

{{< figure src="05-eval-login.png" style="border: 1px solid #000;" height="300px">}}

---
### TeamServer Vulnerability - Hibernate Injection

Your instructor will review the contents of the application:
- Overview
- Vulnerabilities
- Hibernate Vulnerability and how to fix

{{< figure src="05-eval-vulnerability-hibernate.png" style="border: 1px solid #000;" height="300px">}}

---
### Fix the code for DEV

We have a fix already checked into GitHub at branch named `1.5.4-SQLi-fixed` at this location on GitHub:

https://github.com/Contrast-Security-OSS/spring-petclinic/tree/1.5.4-SQLi-fixed

Next, we'll review the fix.

---
### Examine the DEV code difference

On GitHub, navigate to this page to see the code difference with the changes for this vulnerability.  You can see the differences at this link where we commented out the old code and uncommented out new code.

https://github.com/Contrast-Security-OSS/spring-petclinic/commit/5930006b7c75c21472c5c4d33ef520ceed689902

The image below shows the remediation as substituting a more modern query in place of the existing query.

{{< figure src="05-github-hibernate-diff.png" style="border: 1px solid #000;" height="300px">}}
[See the full-sized picture](05-github-hibernate-diff.png)

---
### Reconfigure Jenkins

{{% note %}}
Instructors: Show the users how this is the only change in the branch.
{{% /note %}}

On the Jenkins server, reconfigure the pipeline to use the new branch named `1.5.4-SQLi-fixed` by clicking on the *Configure* link and modifying the *Pipeline* script.

- Comment out the existing Github clone operation.
- Uncomment the new GitHub clone operation.

Your results should look like the following:

```groovy
//                ### TODO INSERT clone operation on next line
//                git branch: '1.5.4-SQLi', url: 'https://github.com/Contrast-Security-OSS/spring-petclinic.git'
//                ### TODO Switch to this branch for a fix
                git branch: '1.5.4-SQLi-fixed', url: 'https://github.com/Contrast-Security-OSS/spring-petclinic.git'
                sh 'echo "unit test"'
```

Re-run your jenkins build to see the longer build succeed.

---
### Successful build results

Navigate to the console output if you wish to see the results of the build succeed.  The console output will have a section similar to the following:

```text
[INFO] --- contrast-maven-plugin:2.8:verify (verify-with-contrast) @ spring-petclinic ---
[INFO] Successfully authenticated to TeamServer.
[INFO] Checking for new vulnerabilities for appVersion [petclinic-20201111200130]
[INFO] Sending vulnerability request to TeamServer.
[INFO] No new vulnerabilities were found.
[INFO] Finished verifying your application.
```

---
{{< slide id="lab-deploy" >}}
## LAB: Deploy the software application

Most teams build software and then deploy them to a testing environment for internal testing (UAT, SIT, QA, and others).

Normally, teams will build an instrumented application. In this module, we won't cover the process of instrumenting an application in detail because these modules already cover those topics: 

- [Module 2](m02-instrumenting-container) covers the details of instrumenting a container. 
- [Module 3](m03-instrumenting-java-app) covers the details of instrumenting a standalone Java application

We use a pre-built container already configured with Contrast.
We will use terraform to distribute the application as a running container on Azure.  

---
### Add your initials and region

Your build will benefit from some more tailoring to make it easier to identify.  We'll add two *String Parameters* for your initials and a region.

- Navigate to the subsection at *General->This project is parameterized*
- Click on the button to *Add Parameter* of type *String Parameter*
- Name your credential as: `initials` and set the Default Value to your initals
- Click a second time on the button to *Add Parameter* of type *String Parameter*
- Name your credential as: `location` and set the Default Value to 'eastus' or what your instructor specifies

{{< figure src="05-terraform-jenkins-add-parameter.png">}}

---
### String Parameters

Your screen should look like the following:

{{< figure src="05-terraform-jenkins-parameter-results.png" height="300px">}}
[See the full-sized picture](05-terraform-jenkins-parameter-results.png)

---
### Enable Terraform commands

In the Jenkins Configuration section for the Pipeline->Script, modify the contents so the follow text is no longer commented in the section for the QA stage:

```groovy
                // TODO: UNCOMMENT TO CREATE TERRAFORM INFRASTRUCTURE.
                // TODO: MAKE SURE TO ADD PARAMETERS FOR location AND INITIALS
                script {
                    withCredentials([azureServicePrincipal('ContrastAzureSponsored')]) {
                        try {
                            sh """
                            export ARM_CLIENT_ID=$AZURE_CLIENT_ID
                            export ARM_CLIENT_SECRET=$AZURE_CLIENT_SECRET
                            export ARM_SUBSCRIPTION_ID=$AZURE_SUBSCRIPTION_ID
                            export ARM_TENANT_ID=$AZURE_TENANT_ID
                            terraform apply -auto-approve -var 'location=$location' -var 'initials=$initials' -var 'environment=qa' -var 'servername=jenkins-$initials' -var 'session_metadata="version=1.5.1"'
                            """
                        } catch (Exception e) {
                            echo "Terraform refresh failed, deleting state"
                            sh "rm -rf terraform.tfstate"
                            currentBuild.result = "FAILURE"
                            error("Aborting the build.")
                        }
                    }
                }
            }
        }

```

---
### Enable Terraform destroy

In the same Pipeline->Script section, modify the contents of the UAT stage so they are no longer commented:

```groovy
        stage("UAT") {
            // TODO: UNCOMMENT TO ASK THE USER TO CONTINUE
            input {
                message "Should we continue?"
                ok "Yes"
            }
            steps {
                // TODO: UNCOMMENT TO DELETE TERRAFORM INFRASTRUCTURE
                script {
                    withCredentials([azureServicePrincipal('ContrastAzureSponsored')]) {
                        try {
                            sh """
                            export ARM_CLIENT_ID=$AZURE_CLIENT_ID
                            export ARM_CLIENT_SECRET=$AZURE_CLIENT_SECRET
                            export ARM_SUBSCRIPTION_ID=$AZURE_SUBSCRIPTION_ID
                            export ARM_TENANT_ID=$AZURE_TENANT_ID
                            terraform destroy -auto-approve
                            """
                        } catch (Exception e) {
                            echo "Terraform delete failed, deleting state"
                            sh "rm -rf terraform.tfstate"
                            currentBuild.result = "FAILURE"
                            error("Aborting the build.")
                        }
                    }
                }
            }
        }

```

Reference: `jenkinsfile-03`

---
### Run the build

Run the build with parameters to run through the earlier unit tests, and then deploy the running application as a container.

The build will pause and wait for your approval to continue.  This gives you time to navigate to the running application.

Your URL should contain your initials and region in this format:

`http:spring-petclinic-mm.eastus.azurecontainer.io:8080`

Review your logfile to find the official answer which will look like this: 

```text
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
Outputs:

contrast = This app should appear in the environment http://192.168.86.118:28080/Contrast
fqdn = http://spring-petclinic-mm.eastus.azurecontainer.io:8080
ip_address = 52.188.88.228

```

---
### Navigate to the application

Browse to the URL for your application.  The application we deploy is at an earlier version and will have the same Hibernate Injection vulnerability.  This means you can replicate the earlier vulnerability results.

---
### Manually test your software to find a new vulnerability

You can navigate to the application and replicate the same failure and see similar results observed via automated testing.

In more established pipelines, we would take the negative results and fail the pipeline.  

For the purpose of this workshop module, we are omitting this functionality.

Your instructor will walk you through the process of accessing the application and replicating the vulnerability.

---
### Testing petclinic

The Petclinic application is a popular open-source java applicaiton many teams use for testing and experimentation.

Navigate to the home page and click on the "Find Owners" section in the upper-right.  

{{< figure src="05-petclinic-homepage.png" height="300px">}}
[See the full-sized picture](05-petclinic-homepage.png)

---
### Enter test data

Most teams have some type of standard-input testing where they enter names, numbers, and other data as common use cases.  Here, let's enter the name `Davis" to produce a response with two rows of data.

Most teams also have a separate activity to perform vulnerability testing.  Contrast Security helps reduce the amount of work you need for this activity because we leverage normal usage to find vulnerabilities.  This is quite valuable to teams because it is not easy to test past vulnerabilities with complex payloads.  It is much easier to reveal vulnerabilities with our IAST inside-out approach.  

{{< figure src="05-petclinic-find-owners.png" height="300px">}}
[See the full-sized picture](05-petclinic-find-owners.png)

---
### Identify the software fix

After you enter the name, `Davis,` navigate to TeamServer to observe the Hibernate injection vulnerability from before.

Your instructor wil walk you through the pages to review the information as before.

---
{{< slide id="final-review" >}}
### Final review of the Jenkinsfile

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
