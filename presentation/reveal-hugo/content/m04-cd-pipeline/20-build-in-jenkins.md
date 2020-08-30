+++
title = "Building the code"
chapter = true
weight = 20
outputs = ["Reveal"]
+++

{{% section %}}
## Building the code in Jenkins

We'll add the build to a Jenkins pipeline.  Rather than build the entire pipeline one step at a time, we'll read in a Jenkinsfile with the definition.  This allows us to focus on the content rather than defining the system.

_NOTE: The sequence here is an outline, and needs revisions for Contrast-forward statements and an embedded pitch.

---
## Run jennkins
Run Jenkins from a container.
Navigate to Jenkins

---
## Review the Jenkinsfile

Study the Jenkinsfile for is content:
- Overall layout of the pipeline stages
- The build step
- Adding our instrumentation
- Deploying the file to an environment
- Testing the environment

_These are all steps that map to conventional DevOps pipelines._

---
## Import the Jenkinsfile

---
## Observe the new pipeline in Jenkins

---
## Run the pipeline to see the build

- Build steps.
- JUnit steps.
- Running test scripts.

Let's investigate this first end-to-end pipeline run.

{{% /section %}}
