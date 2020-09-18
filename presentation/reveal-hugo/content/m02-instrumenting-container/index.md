+++
title = "Module 2: Instrumenting a Container with Contrast Security"
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

Remind your student-users this module assumes working knowledge of Docker.

- Use apps/eval-provisioning/create-orgs.sh to setup your student users with accounts on the Eval TeamServer.
- Use apps/setup.sh to setup and run vulnerable applications in containers on a Kubernetes cluster.  We're configured to use AKS.
- Provision a running VM for each user from a workstation image sourced on Azure.
{{% /note %}}
# Module 2: Instrumenting a Container with Contrast Security

Jump to:
- [Module Introduction](#/module-introduction)
- [Check Out and Build](#/check-out-and-build)
- [Setting up to Build a Container](#/setting-up-to-build-a-container)
- [The WebGoat Container](#/the-webgoat-container)
- [Enhanced Dockerfile](#/enhanced-dockerfile)
- [Conclusion](#/conclusion)

---
{{< slide id="module-introduction" >}}
## Module Introduction

This module is primarily a sequence of hands-on activities.

In this section we'll guide you through a sequence of steps to instrument a Java application, running in a container and deploy it.

This example provides insight into how teams bring Contrast Security into their organization quickly and easily.   While each team may have processes that are tailored to their environment, the general sequence provided here should track to all teams.

---
{{< slide template="info" >}}
# Time and Prerequisites
This Module should take about 40 minutes to complete. 

Be sure to have completed the [prerequisites](../#/2)
  
---
## Objectives

Contrast Security is providing this module as an _interactive_ guide for onboarding a container-based Java application.

- Learn how to instrument a container running a Java application with Contrast Security
- Learn about Contrast Security Agents
- Enhance your deployment with additional fields

---
{{< slide id="check-out-and-build" >}}
## Check out and build

Let's build some code.  In this first part, we will build a Java jar file with our application.

We will use a branch of the open-source example WebGoat from this location to ensure a consistent experience:
https://github.com/Contrast-Security-OSS/WebGoat_BBP_FORK/tree/contrast-demo-webgoat-7.1

_NOTE: This code may already be on your workshop workstation._

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

We will build the code at the command line for the benefit of developers already accustomed to the process.  While you may build via your IDE, we have learned the base CLI example allows most developers to see how the process applies to their day-to-day experiences.

_The following commands check out and build code in the same style and sequence you would on your local machine and CI server._

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
{{< slide id="setting-up-to-build-a-container" >}}
## Setting up to build a container
Modern applications are often deployed in a container, and this module shows how to build a container image which includes the Contrast Security agent. 

We have to walk through a few steps to create the working container, which we'll follow in the next several screens:
- Get the Contrast Agent
- Update your Dockerfile
- Build your image

---
### Get the Contrast Agent
Contrast Security has agents for Java, .Net, and other popular languages.  You can download the Contrast agent from multiple sources including:

* Contrast TeamServer UI
* Contrast TeamServer API
* Package managers including Maven, Nuget, NPM, PyPi and Rubygems.

Let's get it from Contrast TeamServer

---
### Contrast TeamServer Agent Download

Start by logging onto the eval server at https://eval.contrastsecurity.com/Contrast with the credentials your instructor provided to you

{{< figure src="2-teamserver-login.png" height="400px">}}

---
### Download your agent file

In this module, we'll use a popular way for first-time users to get an agent - the TeamServer UI.

In the top toolbar, select the plus sign to add a new application.

{{< figure src="2-teamserver-add-agent.png" >}}

Next, ensure the agent type is Java, and click on the "Download Agent" button to get the jar file.
 
{{< figure src="2-ts-agent-java.png" height="300px"
caption="[See the full-sized picture](2-ts-agent-java.png)"
>}}

---
### Move agent file

Make sure you move the file to the correct directory.  This folder is usually the "Downloads" folder on your Windows workstation, and you can copy the file to the <b>webgoat</b> working directory with this command

```commandline
cd %HOMEPATH%\webgoat
copy %HOMEPATH%\Downloads\contrast*.jar .
 
```

This places the contrast jar file in the same directory where we'll build our Docker image.

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

One option to automate the download the agent is to use curl to get the latest version from  Maven Central.

You may even specify a version instead of the latest.

Here is the raw curl command which downloads the Contrast agent for Linux systems:

```commandline
curl --fail --silent --location "https://repository.sonatype.org/service/local/artifact/maven/redirect?r=central-proxy&g=com.contrastsecurity&a=contrast-agent&v=LATEST" -o /opt/contrast/contrast.jar
```

And for Windows Systems:
```commandline
curl --fail --silent --location "https://repository.sonatype.org/service/local/artifact/maven/redirect?r=central-proxy&g=com.contrastsecurity&a=contrast-agent&v=LATEST" -o %HOMEPATH%\contrast.jar
```

Windows Powershell users:
```powershell
Invoke-WebRequest -Uri "https://eval.contrastsecurity.com/Contrast/api/ng/$(contrast-id)/agents/default/JAVA" -OutFile .\contrast.jar
```

See this link for a listing of available Java agents on Maven Central:
https://repository.sonatype.org/#nexus-search;quick~com.contrastsecurity

---
{{< slide id="the-webgoat-container" >}}
## The WebGoat Container
{{% note %}}
Some teams have a build-test-deploy lifecycle built into their Dockerfile.  We are only doing build.
{{% /note %}}

Once you have a jar file, the agent, and your `contrast_security.yaml` file, you have all the pieces to build a Docker image.

Teams have different Dockerfile strategies.  In this module, we are using a simple model. 

Your Dockerfile is on your workstation as `%HOMEPATH%\webgoat\Dockerfile`, and this gist is a copy of that file:
{{< gist marcoman df3cabe88865d8dc38e499843df96f5a >}}

Let's examine the contents of the DockerFile next.

---
### Dockerfile deconstructed
{{% note %}}
Your teams may use other images, as long as the container environment supports the requirements.

Some teams create a corporate base image and add common libraries and configuration to be shared across all of their applications.  This model helps those teams reduce the time needed to re-package the same items, and helps establish consistency.  Those teams will add the Contrast Security agent to the base image.  This module focuses on a simpler model, where the techniques apply to corporate base image.

{{% /note %}}

The first line is the declaration of the base image for your container.  

For this exercise, we're using a Linux-based image that includes Java named `openjdk:8-slim`.  
  
```dockerfile
# Ensure the contrast security jar is downloaded and available as "contrast.jar" in the appropriate directory.
FROM openjdk:8-slim
```

---
{{< slide template="info" >}}
### Java agent requirements

Visit this page if you want to see more details about Java agent requirements.

https://docs.contrastsecurity.com/en/java-supported-technologies.html

---
### Add the application definition
{{% note %}}
The common operation is to transfer the binary to a subdirectory on the running container.  Sometimes there is additional configuration in the form of files or environment variables, and that is specific to your application definition.
{{% /note %}}

The next three commands are where we add the application to the container definition.  

Since we already have a jar file, we'll copy it to the container.

```dockerfile
RUN mkdir /webgoat7.1
WORKDIR /webgoat7.1
ADD ./webgoat-container/target/webgoat-container-7.1-war-exec.jar /webgoat7.1/webgoat-container-7.1-exec.jar
```
---
### Add the contrast security agent
{{% note %}}
We'll continue to rely on a simple model of adding the agent to your container.
{{% /note %}}

The next step is to add the contrast agent to the container definition.  

As with the application, the process is about transferring the binary to a subdirectory on the system.  

```dockerfile
RUN mkdir /opt/contrast
ADD contrast.jar /opt/contrast
```
Contrast Security supports the local best practices your teams may use to to download the agent:
- A dependency in their maven (or gradle) file for the specific version of the agent
- A step in their CI process to acquire the agent
- A line in their Dockerfile to perform a curl operation on an external repository.

---
### Add the `contrast_security.yaml`

The `contrast_security.yaml` has details to enable your Java agent to communicate with TeamServer, including the TeamServer URL.  

The file you download is short and can be extended with many more fields to suit the needs of your team.  

```dockerfile
ADD contrast_security.yaml /opt/contrast
```

See the online documentation for more examples of how to enhance the configuration of an application.

---
{{< slide template="warning" >}}
### Secrets

In this module, we are including the contrast_security.yaml file directly into your docker image for the purpose of the training exercise.  The better way is to pass in environment variables with the same information, which we'll cover later in this module.

---
### Configure environment variables
{{% note %}}
You add details specific to your application, secrets, and other unique values via environment variables.  Some of the details in the `contrast_security.yaml` file may also be supplied via environment variables, but we'll continue keeping the model simple for this exercise.
{{% /note %}}

You can define values via environment variables, or with the `contrast_security.yaml` file.  

We are using environment variables to avoid editing the `contrast_security.yaml` file.

The environment variables below identify the path to the contrast agent, and the security file:

```dockerfile
ENV JAVA_TOOL_OPTIONS "-javaagent:/opt/contrast/contrast.jar \
    -Dcontrast.java.agent.standalone_app_name=Webgoat \
    -Dcontrast.config.path=/opt/contrast/contrast_security.yaml \ 
    -Dcontrast.application.tags=workshop,webgoat"
```
---
### Build the Docker image
Let's build the Docker image:

```commandline
cd %HOMEPATH%\webgoat
docker build . -t workshop/contrast-demo-java-webgoat:1.0

```

The command above instructs Docker to build the image using the Dockerfile in the current folder, and this image should be tagged as 'workshop/contrast-demo-java-webgoat'.  

---
### Verify Docker image
This command verifies the existence of your Docker image:

```commandline
docker image ls
REPOSITORY                             TAG                 IMAGE ID            CREATED             SIZE
workshop/contrast-demo-java-webgoat    1.0                 35fc72aaeb50        7 seconds ago       356MB
openjdk                                8-slim              f7e86cc84bae        5 days ago          300MB
mcr.microsoft.com/windows/servercore   ltsc2019            561b89eac394        3 months ago        3.7GB
mcr.microsoft.com/windows              1809                2de0138f1799        3 months ago        8.88GB
mcr.microsoft.com/windows/nanoserver   1809                9e7d556b2b51        3 months ago        251MB
```

---
### Run the image
Let's try this with the container we have created.

```commandline
docker run -p 8080:8080 workshop/contrast-demo-java-webgoat:1.0

``` 

Now we're ready to navigate to the application, it should be running at [http://localhost:8080](http://localhost:8080).

---
### Stop the running container

Run the following command to see your running docker container:

```commandline
docker container ls

```

You should see you image listed as below:
```commandline
CONTAINER ID        IMAGE                                        COMMAND                  CREATED             STATUS              PORTS                    NAMES
7fb59741c6fe        workshop/contrast-demo-java-webgoat:latest   "java -jar /webgoat7…"   10 minutes ago      Up 10 minutes       0.0.0.0:8080->8080/tcp   agitated_hamilton
```

Stop the running container with the following command, using the ID above as an example (`7fb59741c6fe`)

```commandline
docker container stop 7fb59741c6fe
```

---
{{< slide id="enhanced-dockerfile" >}}
## Enhanced Dockerfile

Next, we'll improve the Dockerfile to remove the embedded `contrast_security.yaml` file.  We'll use environment variables instead.
The new Dockerfile is shown below (and is named Dockerfile2 on disk)

```dockerfile
# Ensure the contrast security jar is downloaded and available as "contrast.jar" in the appropriate directory.
FROM openjdk:8-slim
RUN mkdir /webgoat7.1
WORKDIR /webgoat7.1
ADD ./webgoat-container/target/webgoat-container-7.1-war-exec.jar /webgoat7.1/webgoat-container-7.1-exec.jar
RUN mkdir /opt/contrast
ADD contrast.jar /opt/contrast
EXPOSE 8080
ENTRYPOINT ["java","-jar","/webgoat7.1/webgoat-container-7.1-exec.jar"]
```

---
### Rebuild the container

The enhanced Dockerfile is already present on your system as `Dockerfile2`.  In this next command, we'll specify the file in the build operation:

```commandline
cd %HOMEPATH%\webgoat
docker build -f Dockerfile2 . -t workshop/contrast-demo-java-webgoat:2.0

```
---
### Running the container

You now need to pass the values from your contrast_security.yaml file as environment variables.  Run the docker file with values plugged into the values indicated by {} below:

```commandline
docker run -e CONTRAST__URL=https://eval.contrastsecurity.com/Contrast 
    -e CONTRAST__API__API_KEY={YOUR_API_KEY}
    -e CONTRAST__API__SERVICE_KEY={YOUR_SERVICE_KEY}
    -e CONTRAST__API__USER_NAME={YOUR_USERNAME}
    -p 8080:8080 workshop/contrast-demo-java-webgoat:2.0
``` 

---
### Running with a helper script

We also have a helper script to make this step easier.  Execute the following commands where you will be asked to supply the following details:
- `{org_uuid}`
- `{api_key}`
- `{authorization_key}`
- `{username}`
- `{service_key}`

```commandline
cd %HOMEPATH%\workshop\scripts\module2
setup.bat

```

---
### Order of Preference
Given that an agent can be configured through multiple methods it is important to understand that there is an order of precedence applied:

1. System property value
2. Environment variables
3. YAML configuration file value

The online documentation from Contrast Securty explains the options in greater detail.

---
### Testing the application

Navigate to the URL of the application and observe how TeamServer picks up on the new application.

Click through some screens, test some paths, show cause-and-effect from the application to TeamServer.

---
### Stop the running container

When you done running your application, run the following command to see your running docker container, and use the Container ID to stop the running container.

```commandline
docker container ls
CONTAINER ID        IMAGE                                        COMMAND                  CREATED             STATUS              PORTS                    NAMES
7fb59741c6fe        workshop/contrast-demo-java-webgoat:latest   "java -jar /webgoat7…"   10 minutes ago      Up 10 minutes       0.0.0.0:8080->8080/tcp   agitated_hamilton
```

Stop the running container with the following command, using the ID above as an example (`7fb59741c6fe`)

```commandline
docker container stop 7fb59741c6fe
```

---
# Wrap-up
{{% note %}}
Close out the session with your team.
{{% /note %}}

In this hands-on example, you have seen how Contrast Security works with a Java application running in a containter.  We also explained options teams use when integrating Contrast Security into your CI/CD pipeline to better support automation, secrets, and deployments.

Your instructor will provide guidance as needed.

---
{{< slide id="conclusion" >}}
## Conclusion
This concludes the module.
Your instructor will inform you about how long your environment will remain in operation and if you will be covering other modules.

Go back to the [module list](../#/module-list)  
