+++
title = "Module 3: Instrumenting a Java Application"
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

Explain to your student users there is overlap with this module and the module where we instrument a java application.
Remind your student-users this module assumes working knowledge of using a command-line, Java, and building code.

- Use apps/eval-provisioning/create-orgs.sh to setup your student users with accounts on the Eval TeamServer.
- Use apps/setup.sh to setup and run vulnerable applications in containers on a Kubernetes cluster.  We're configured to use AKS.
- Provision a running VM for each user from a workstation image sourced on Azure.
{{% /note %}}
# Module 3: Instrumenting a Java Application

Jump to:
- [Module Introduction](#/module-introduction)
- [Software Process](#/software-process)
- [Check out and build](#/check-out-and-build)
- [Environment Variables](#/environment-variables)
- Other Configuration options
- [Conclusion](#/conclusion)

---
{{< slide id="module-introduction" >}}
## Introduction

This module is primarily a sequence of hands-on activities.

In this section we'll guide you through a sequence of steps to instrument a Java application and deploy it to run with Contrast Security.

This example provides insight into how teams bring Contrast Security into their organization quickly and easily.   While each team may have processes that are tailored to their environment, the general sequence provided here should track to all teams.

---
{{< slide template="info" >}}
# Time and Prerequisites
This Module should take about 45 minutes to complete. 

Be sure to have completed the [prerequisites](../#/2)  

---
## Objectives

Contrast Security is providing this module as an _interactive_ guide for onboarding a Java application.

- Learn how to instrument a free-standing Java application with Contrast Security
- Learn about Contrast Security Agents
- Enhance your deployment with additional fields

---
{{< slide id="software-process" >}}
## The Software Sequence
We have to walk through several steps that mirror a software development lifecycle:
- Get Code
- Build the application
- Run the application
- Add the Contrast Security agent
- Re-Run the application
- Explore configuration options

---
{{< slide id="check-out-and-build" >}}
## Check out and build

Let's build some code.  In this first part, we will build a Java jar file with our application.

We will use a branch of the open-source example WebGoat from this location to ensure a consistent experience:

https://github.com/Contrast-Security-OSS/WebGoat_BBP_FORK/tree/contrast-demo-webgoat-7.1

Check out the code on your workstation with the following commands:

```commandline
cd %HOMEPATH%
git clone https://github.com/Contrast-Security-OSS/workshop
git clone https://github.com/Contrast-Security-OSS/WebGoat-Lessons-BBP.git webgoat-lessons
git clone https://github.com/Contrast-Security-OSS/WebGoat_BBP_FORK.git webgoat
```

---
### Walk through the directory structure

If you are curious, navigate through the directory structure to see the different files and its organization.  This is a maven project, split up into different types of targets.  The project README contains more details.

---
### Build the code - Step 1
{{% note %}}
You can get maven from this location:
https://apache.claz.org/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.zip

Instructions:
https://maven.apache.org/install.html
{{% /note %}}

We will build the code at the command line for the benefit of developers already accustomed to the process.

The following commands check out and build code in the same style and sequence you would on your local machine and CI server.

The first step is to setup the project...
```commandline
cd %HOMEPATH%\webgoat
git checkout contrast-demo-webgoat-7.1
mvn clean compile install
```

---
### Build the code - Step 2

Next, build the lesson materials...

```commandline
cd %HOMEPATH%\webgoat-lessons
git checkout develop
mvn package
xcopy "target\plugins\*.jar" "..\webgoat\webgoat-container\src\main\webapp\plugin_lessons\"
```

---
### Build the code - Step 3

The final step is to combine the results into a jar file.
```commandline
cd %HOMEPATH%\webgoat
mvn package
cd webgoat-container\target
```
You now have a working jar file.  This next command runs your application:

```commandline
java -jar webgoat-container-7.1-war-exec.jar
```

You now have a working jar file, and you can browse to your application at:
[http://localhost:8080/WebGoat](http://localhost:8080/WebGoat)

You can exit the application with `CTRL-C`.

---
### Get the Contrast Agent
Contrast Security has agents for Java, .Net, and other popular languages.  You can download the Contrast agent from multiple sources including:

* Contrast TeamServer UI
* Contrast TeamServer API
* Package managers including Maven, Nuget, NPM, PyPi and Rubygems.

Let's get it from <b>Contrast TeamServer.</b>

---
### Contrast TeamServer Agent Download
First-time users typically get their agent from the TeamServer UI.

Log on to the eval server at https://eval.contrastsecurity.com/Contrast with the credentials your instructor provided to you

{{< figure src="2-teamserver-login.png" height="400px">}}

---
### Download your agent file
In the top toolbar, select the plus sign to add a new application.

{{< figure src="2-teamserver-add-agent.png" >}}

Ensure the agent type is Java, and click on the "Download Agent" button to get the jar file.
 
{{< figure src="2-ts-agent-java.png" height="300px"
caption="[See the full-sized picture](2-ts-agent-java.png)"
>}}

---
### Copy agent file

Make sure you move the file to the correct directory.  

This folder is usually the "Downloads" folder on your Windows workstation, and you can copy the file to the <b>webgoat</b> working directory with this command

```commandline
cd %HOMEPATH%\webgoat
copy %HOMEPATH%\Downloads\contrast*.jar . 
 ```

This places the contrast jar file in the same directory where we'll run our application.

---
### Get the `contrast_security.yaml` file
The file `contrast_security.yaml` contains information to connect your running application with TeamServer.

In TeamServer, skip to the next step to download the basic configuration file as shown in the image below.

{{< figure src="2-ts-agent-contrast-yaml.png" height="350px"
caption="[See the full-sized picture](2-ts-agent-contrast-yaml.png)">}}

---
### Copy `contrast_security.yaml`
Copy this file to your working directory:

```commandline
cd %HOMEPATH%\webgoat
copy %HOMEPATH%\Downloads\contrast_security.yaml . 
```

NOTE: More details about configuration options are available at this location: https://docs.contrastsecurity.com/en/java.html#java-template

---
### Example `contrast_security.yaml`

This is representative example of a `contrast_security.yaml` file.  The values for the `api_key, service_key,` and `user_name` are specific to your account and represent your secrets.

This file can be extended with extra fields, and we will show some additional items later in this module.

{{< gist marcoman 786f3459d1865eec7c78adfd4f1545fc >}}

---
### Examine your working directory

Your webgoat working directory should look similar to the the image below, with the newly added `contrast.jar` and `contrast_security.yaml` files:

```commandline
dir %HOMEPATH%\webgoat

 Volume in drive C is Windows
 Volume Serial Number is AEDA-A7B9

 Directory of C:\Users\marco\webgoat

08/10/2020  02:46 PM    <DIR>          .
08/10/2020  02:46 PM    <DIR>          ..
08/10/2020  02:25 PM               982 .gitignore
08/10/2020  02:25 PM             2,756 .travis.yml
08/10/2020  02:25 PM             3,549 azure-pipelines.yml
08/10/2020  02:25 PM                54 catalina.policy
08/10/2020  02:45 PM         9,327,118 contrast.jar
08/10/2020  02:45 PM               211 contrast_security.yaml
08/10/2020  02:25 PM               430 Dockerfile
08/10/2020  02:25 PM               130 mvn-debug
08/10/2020  02:25 PM            14,786 pom.xml
08/10/2020  02:25 PM             8,615 README.MD
08/10/2020  02:31 PM    <DIR>          webgoat-container
08/10/2020  02:25 PM    <DIR>          webgoat-images
08/10/2020  02:33 PM    <DIR>          webgoat-standalone
08/10/2020  02:25 PM             7,173 webgoat_developer_bootstrap.sh
              11 File(s)      9,365,804 bytes
               5 Dir(s)  98,471,391,232 bytes free
```
---
### Alternate agent downloads

One option to automate the download the agent is to use curl to get the latest version from  Maven Central, or a specific version.

This curl command downloads the Contrast agent for Linux systems:

```shell script
curl --fail --silent --location "https://repository.sonatype.org/service/local/artifact/maven/redirect?r=central-proxy&g=com.contrastsecurity&a=contrast-agent&v=LATEST" -o /opt/contrast/contrast.jar
```

Windows Systems:
```commandline
curl --fail --silent --location "https://repository.sonatype.org/service/local/artifact/maven/redirect?r=central-proxy&g=com.contrastsecurity&a=contrast-agent&v=LATEST" -o %HOMEPATH%\contrast.jar
```

Windows Powershell:
```powershell
Invoke-WebRequest -Uri "https://eval.contrastsecurity.com/Contrast/api/ng/$(contrast-id)/agents/default/JAVA" -OutFile .\contrast.jar
```

See this link for a listing of available Java agents on Maven Central:
https://repository.sonatype.org/#nexus-search;quick~com.contrastsecurity

---
### Requirements for the Contrast Security Java agent

We have already seen how we can easily run a java application from a jar file with this command:
```commandline
java -jar webgoat-container-7.1-war-exec.jar
```

You can run the same application with the Contrast Security agent by adding a few extra options at the command line to specify
- The Contrast Security agent 
- The Contrast Security configuration file with your secrets

We will cover this on the next page.

---
### Running the agent with Contrast Security

We'll start by expanding the command over several lines to highlight different arguments where, 
- The path to your configuration file.
- The name of the application in TeamServer
- The path to the agent jar file
- The path to the application jar

```shell script
java -Dcontrast.config.path=contrast_security.yaml 
-Dcontrast.application.name=myname-webgoat
-javaagent:contrast.jar 
-jar webgoat-container-7.1-war-exec.jar
```

---
### Run your application
Run these commands to start the application with Contrast Security enabled:

TODO: Add your name to the command below

```commandline
cd %HOMEPATH%\webgoat\
java -Dcontrast.config.path=contrast_security.yaml -Dcontrast.application.name=yourname-webgoat-javaagent:contrast.jar -jar webgoat-container\target\webgoat-container-7.1-war-exec.jar 
```

---
### Navigate to TeamServer

Navigate back to https://eval.contrastsecurity.com/Contrast with the credentials your instructor provided to you.

{{< figure src="2-teamserver-login.png" height="400px">}}

---
### TeamServer Notification
Click on the bell icon in the upper right-hand corner to see notifications alerting us to the automatic onboarding of your new appplications and their servers.

{{< figure src="01-notifications-new-applications.png" height="400px" >}}
[See the full-sized picture](01-notifications-new-applications.png)

Click into the application that matches your name.

---
### Review the TeamServer Dashboard
Click into the different pages for your onboarded application to see some of the details Contrast Security collects when we onboard this java application.

{{< figure src="../images/04-dashboard.png#center" height="400px" >}}
[See the full-sized picture](../images/04-dashboard.png)

---
### Other properties

The agent provides a number of useful properties you can examine with the command:

`java -jar contrast.jar properties`


```commandline
java -jar contrast.jar properties
*** Contrast Agent (version 3.7.7.16256)
CONFIG_PATH:

  Description: the path to the yml properties file, ie: /path/to/contrast_security.yml

  Environment Variable: CONTRAST_CONFIG_PATH
  System Property: -Dcontrast.config.path
...
```

The `contrast.config.path` System property shown above is a command-line parameter.  In addition to System Properties, we also allow for Environment Variables and described next.

We encourage users to explore the different properties, as there are over 180 options available.

---
{{< slide id="environment-variables" >}}
## Environment variables 
{{% note %}}
Instructors - explain how the translation from the YAML Path to an Environment variable replaces periods (.) with double underscores, so `api.service_key` becomes `CONTRAST__API__SERVICE_KEY.`  Existing underscores are left as-is, which sometimes confuses users. 
{{% /note %}}

Many teams find it convenient to use environment variables to configure their operations.

The contents of the `contrast_security.yaml` file can instead be supplied via environment variables with these definitions:

```commandline
set CONTRAST__API__URL=https://eval.contrastsecurity.com/Contrast
set CONTRAST__API_KEY=YOUR_API_KEY
set CONTRAST__API__USER_NAME=YOUR_USERNAME
set CONTRAST__API__SERVICE_KEY=YOUR_SERVICE_KEY
```

---
### Set your environment variables

At your command prompt, enter each line and replace the contents with your details.
Your instructor will guide you through each line.

```commandline
set CONTRAST__API__URL=https://eval.contrastsecurity.com/Contrast
```

```commandline
set CONTRAST__API__API_KEY=YOUR_API_KEY
```

```commandline
set CONTRAST__API__USER_NAME=YOUR_USERNAME
```

```commandline
set CONTRAST__API__SERVICE_KEY=YOUR_SERVICE_KEY
```

```commandline
set CONTRAST__APPLICATION__NAME=Your new app name
set CONTRAST__APPLICATION__TAGS=webgoat,yourname
```

---
### Run with environment variables

Once set, you can next run your application with a command that does _not_ include a reference to `contrast_security.yaml`

```commandline
cd %HOMEPATH%\webgoat\
java -javaagent:contrast.jar -jar webgoat-container\target\webgoat-container-7.1-war-exec.jar
```

---
### Common Configuration Options

- Application name
- Application Tags
- Server Tags
- Metadata

It is convenient to tag your application and server with keyboards to help you better sort and find your applications.  For example, you may 
- tag an application by language `java`, sprint `s20-1`
- tag a server with the provider (aws, azure), OS (linux, Windows)
- other details important for your team

The next pages show examples based on the details above. 
 
---
### Try System Properties
Copy the example below with your own details to see the application run with your details.

```shell script
java  
-Dcontrast.api.url=https://eval.contrastsecurity.com/Contrast
-Dcontrast.api.api_key=YOUR_API_KEY
-Dcontrast.api.service_key=YOUR_SERVICE_KEY
-Dcontrast.api.user_name=YOUR_USERNAME
-Dcontrast.application.name=sysprop-webgoat
-Dcontrast.application.metadata=GITHASH
-Dcontrast.application.tags=workshop,webgoat,java
-javaagent:contrast.jar
-jar webgoat-container-7.1-war-exec.jar 
```

---
### Try Environment Variables
Copy the example below with your own details to see the application run with your details.

One advantage of environment variables is they are preferred over command-line options because the values are not visible in process viewers that show the details of your invocation.  This is an example in Linux:

```shell script
SET CONTRAST__API__URL=https://eval.contrastsecurity.com/Contrast
SET CONTRAST__API__API_KEY=YOUR_API_KEY
SET CONTRAST__API__SERVICE_KEY=YOUR_SERVICE_KEY
SET CONTRAST__API__USER-NAME=YOUR_USERNAME
SET CONTRAST__APPLICATION__NAME=env-webgoat
SET CONTRAST__APPLICATION__METADATA=GITHASH
SET CONTRAST__APPLICATION__TAGS=workshop,webgoat,java
java -javaagent:contrast.jar -jar webgoat-container-7.1-war-exec.jar 
```
---
### Other configuration details

Other popular configuration details include:

- Log Levels, Logfile locations, log configurations (`CONTRAST__AGENT__LOGGER__LEVEL`, `CONTRAST__AGENT__SECURITY_LOGGER__PATH`)

- Network configuration (`PROXY_ENABLED`, `PROXY_URL`, others)

- Also, `CONTRAST__ENABLE`


---
# Wrap-up
{{% note %}}
Close out the session with your team.
{{% /note %}}

In this hands-on example, you have seen how Contrast Security works with a Java application.  We also explained options teams use when integrating Contrast Security into your CI/CD pipeline to better support automation, secrets, and deployments.

Your instructor will provide guidance as needed.

---
## Conclusion
This concludes the module.
Your instructor will inform you about how long your environment will remain in operation and if you will be covering other modules.

Go back to the [module list](../#/module-list)  
