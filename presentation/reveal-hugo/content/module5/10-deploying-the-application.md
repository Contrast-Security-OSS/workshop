+++
title = "Module 5 - Running with Contrast Security"
chapter = true
description = "Module 5 is a self-directed workshop introducing the major values of using Contrast Security"
weight = 10
+++

{{% section %}}
## Deploying your application
This workshop is designed to have you deploy an application so you can see its data added as part of an onboarding lifecycle.
 
 We'll start with the deployment of the docker container that contains already instrumented code.  We have already configured your container with a Contrast Security agent plus details to point to the right TeamServer.  Your task is to start this container with the running application and observe how it will automatically register with the server and start generating results.
 
 Run these command in a command line window:
  
 ```shell script
cd /Users/contrast
git clone <url to repository> workshop
cd workshop
docker-compose up
```

This process will run the container on your local system and you can observe the log files in real time.

---
## What happens when you deploy an application?
When you deploy your instrumented application, a few things happen:
- The agent connects with the remote TeamServer
- The agent starts sending data for the application
- If licenses are available, details for the application are visible in TeamServer

In the next section, we'll look at working with the Contrast Security User Interface running on TeamServer.

---
### Environment Variables

The minimum set of environment variables required are as follows:

```text
$ env | grep CONTRAST
CONTRAST__API__URL=http://eval.contrastsecurity.com/Contrast
CONTRAST__API__KEY=YOUR_API_KEY
CONTRAST__API__USER_NAME=YOUR_USERNAME
CONTRAST__API__SERVICE_KEY=YOUR_SERVICE_KEY
```

This is the most flexible approach as it is very easy to set these properties when using a CI/CD tool or configuring the agent for use within a cloud environment.



{{% /section %}}