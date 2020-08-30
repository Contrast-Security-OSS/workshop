+++
title = "Module 2 - Instrumenting a Container"
chapter = true
weight = 11
outputs = ["Reveal"]
+++

{{% section %}}
## Building a container

Modern applications are often deployed within containers so during this module we will learn how to build a container image which includes the Contrast Security agent. 

We will need to download and enable the agent within our container image, in the next part we'll cover how we run the container.

---
The Contrast agent can be downloaded from multiple sources including:

* Contrast TeamServer UI
* Contrast TeamServer API
* Package managers including Maven, Nuget, NPM, PyPi and Rubygems.

We recommend that the agent is obtained from package managers within a CI/CD environment.

---
In this example we will be working with the Java agent which is included within the Maven Central repository. In this Dockerfile we will use curl to download the agent, ensuring that we get the latest version each time we build our container image.

https://github.com/Contrast-Security-OSS/WebGoat_BBP_FORK/blob/contrast-demo-webgoat-7.1/Dockerfile

TODO: Update this Dockerfile for Maven Central approach.

{{< gist marcoman df3cabe88865d8dc38e499843df96f5a >}}

---
Here is the raw curl command which downloads the Contrast agent:

```shell script
curl --fail --silent --location "https://repository.sonatype.org/service/local/artifact/maven/redirect?r=central-proxy&g=com.contrastsecurity&a=contrast-agent&v=LATEST" -o /opt/contrast/contrast.jar
```

---
Next we need to enable the agent. One way of doing this with Java is to set an environment variable called JAVA_TOOL_OPTIONS which informs the JVM that we would like to use a Java agent:

```shell script
ENV JAVA_TOOL_OPTS='-javaagent:/opt/contrast/contrast.jar -Dcontrast.java.agent.standalone_app_name=Webgoat'
```

In the variable above, we have specified that the application should be called "Webgoat" when we see it listed within the TeamServer environment.

_Note: It would also be possible for us to enable the agent at runtime rather than by default_

---
Let's go ahead and build the Docker image:

```shell script
cd <checkout directory>
docker build . -t workshop/contrast-demo-java-webgoat 
```

The command above instructs Docker to build the image using the Dockerfile in the current folder, and this image should be tagged as 'workshop/contrast-demo-java-webgoat'.

---
Run the following command to see the docker image:

```shell script
docker image ls | grep workshop
```

You should see you image listed as below:

```shell script
workshop/contrast-demo-java-webgoat                  latest                    61055e9236fa        11 days ago         170MB
```

---
Show the public repository with the Docker images.
Explain how we are providing these versions as references.

TBD: Need a public repository

{{% /section %}}
