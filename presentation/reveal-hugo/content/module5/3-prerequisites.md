+++
title = "Setup and Prerequisites"
chapter = true
weight = 3
outputs = ["Reveal"]
+++

{{% section %}}
# Setup and Prerequisites

This workshop has a few prerequisites and infrastructure requirements.

When Contrast Security is hosting the workshop, most requirements will be setup for you.  You may skip these instructions as directed by your instructor.

---
## Logging on to your workshop workstation

In Contrast-guided workshops, your instructor will provide you with a cloud-based workstation configured with tools and scripts.

Your Contrast Security instructor or counterpart will supply you with the network address and credentials to log on. You should assume you will be running all operations from that workstation, as it is equipped with a common set of infrastructure to best ensure the workshop operations.

---
## Your IDE - Eclipse

In this workshop, you will be using Eclipse.  Eclipse is already installed on your workstation.

---
## Contrast TeamServer

TeamServer is where you send data and information about your running applications and servers.  

In this workshop, we'll use the Contrast Security Evaluation Saas offering at this location:
https://eval.contrastsecurity.com

There are two parts to your credentials:

- Traditional username + password to access the site via the URL listed above. 
- The configuration file `contrast_security.yaml` is API and application agents.  These details include an API Key, Authorization Headers, and API Username are for CLI and other API transactions.

In the workshops, you will the credentials in different exercises.

---
## Contrast Teamserver - Community Edition

Self-directed workshops use the Community Edition of TeamServer.  Your Contrast Security team will tell you when to use this in lieu of the Eval server.
