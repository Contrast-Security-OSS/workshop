+++
title = "Module 2 - Instrumenting a Container"
chapter = true
weight = 12
outputs = ["Reveal"]
+++

{{% section %}}
## Running the container

In this part, we'll configure and run the container with the Contrast agent enabled. 

There are a number of ways to configure the Contrast Java agent including system properties, a YAML configuration file or environment variables. The method you choose may vary depend upon your environment and how you currently build your infrastructure so we will introduce the available options here.

---
Given that an agent can be configured through multiple methods it is important to understand that there is a an order of precedence applied:

1. System property value
2. Environment variables
3. YAML configuration file value

We will show examples of each method during this module, then we will use the environment variables option as this is the most flexible when working with containers.

---
There are a minimum set of configuration values that need to be set in order the for agent to communicate with the Contrast TeamServer, these are:

* Contrast URL
* API key
* Agent username
* Agent service key

To find the credentials:

1. Select User name > Organization Settings in the top right corner.
2. Select API in the left navigation to see these values.

---
If we want to configure the Java agent using system properties then we would simply provide these when starting the Java process like so:

```shell script
java -javaagent:contrast.jar -Dcontrast.api.url=https://eval.contrastsecurity.com/Contrast -Dcontrast.api.api_key=YOUR_API_KEY -Dcontrast.api.service_key=YOUR_SERVICE_KEY -Dcontrast.api.user_name=YOUR_USERNAME -jar your_application.jar
```

---
Alternatively, if you do not need to change any of your agent properties at runtime then you can use a YAML file for configuration:

{{< gist marcoman 786f3459d1865eec7c78adfd4f1545fc >}}

---
Finally, we can also set these values using environment variables. The minimum set of environment variables required are as follows:

```shell script
$ env | grep CONTRAST
CONTRAST__API__URL=http://eval.contrastsecurity.com/Contrast
CONTRAST__API__KEY=YOUR_API_KEY
CONTRAST__API__USER_NAME=YOUR_USERNAME
CONTRAST__API__SERVICE_KEY=YOUR_SERVICE_KEY
```

This is the most flexible approach as it is very easy to set these properties when using a CI/CD tool or configuring the agent for use within a cloud environment.

---
Let's try this with the container we have created.

To apply environment variables when you run your docker container, you can use the `-e` command line setting, for example:

```shell script
docker run \
    -e CONTRAST__URL=https://eval.contrastsecurity.com/Contrast \
    -e CONTRAST__API__API_KEY=YOUR_API_KEY \
    -e CONTRAST__API__SERVICE_KEY=YOUR_SERVICE_KEY \
    -e CONTRAST__API__USER_NAME=YOUR_USERNAME \
    -p 8080:8080 workshop/contrast-demo-java-webgoat:latest
``` 

Now we're ready to navigate to the application, it should be running at [http://localhost:8080](http://localhost:8080).

{{% /section %}}
