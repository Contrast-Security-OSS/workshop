+++
title = "About Contrast Security"
chapter = true
weight = 1
outputs = ["Reveal"]
+++

{{% section %}}


# About Contrast Security

Contrast Security is an automated security testing solution that infuses software with vulnerability assessment capabilities so that security flaws are automatically identified. Contrast Security utilizes dynamic binary instrumentation to identify vulnerabilities in web applications and APIs. Organizations can use Contrast Assess to secure their applications without changing the application software stack or how they build, test, or deploy code. The result is accurate, continuous vulnerability assessment that integrates seamlessly with existing software development and security processes, scales across the software development lifecycle and the entire application portfolio, and easily outpaces traditional solutions.

---
## Contrast Assess - IAST

Contrast Assess neither scans nor attacks applications but, instead, uses patented, state-of-the-art, deep security instrumentation technology to combine the most effective elements of static and dynamic testing, software composition and configuration analysis technologies, delivering them directly into applications. As you can see on the following picture, Contrast instruments not just the custom code but other elements of the application as well providing far better coverage as compared with other application security solutions.

<img src="images/01-sensors.png" style="border: 0px solid #000; background:none; box-shadow:none">


As we discussed, Contrast Security is unique in the way how it identifies vulnerabilities. Now let's take a look at some of the benefits of this approach.

---
## Highest Accuracy 

Instrumentation allows Contrast Security to report the vulnerabilities from the inside of applications which produces highly accurate results without dependence on security experts. In addition, Contrast Security combines the most effective elements of Interactive (IAST), Static (SAST), and Dynamic (DAST) application security testing technology, software composition analysis (SCA), and configuration analysis, delivering them directly into applications. This combination of techniques produces the telemetry necessary to detect vulnerabilities with virtually no false positives and no false negatives.

---
## Scalable Architecture

Contrast Assess scales because it instruments application security into each application, delivering and distributing vulnerability assessment across an entire application portfolio. Every running application continuously produces results in parallel. Contrast differs from legacy approaches that require application security experts – a human element that does not scale. Even with hundreds or thousands of applications, Contrast Assess provides an always up-to-date dashboard for each application with vulnerability, library, architecture, and other security details. 

---
## Contrast is ideal for DevSecOps

Unlike legacy approaches that require time-consuming, late-stage scans that disrupt the development process, there is no separate security testing phase with Contrast Assess. Contrast Assess uses its deep security instrumentation to produce a continuous stream of accurate vulnerability analysis whenever and wherever software is run. Development, QA, DevOps, and security teams get results as they develop and test software, enabling them to find and fix security flaws early in the software lifecycle when they are easiest and cheapest to remediate. 

Contrast Security enables DevOps teams to deliver security-as-code by:

- Empowering developers to embed security as early as possible in the cycle
- Providing continuous vulnerability assessment throughout SDLC (see the following picture)
- Automating security into the pipeline
- Monitoring attacks the way you monitor performance

{{< figure src="home/contrast2.png" style="border: 1px solid #000;" height="200px">}}
[See the full-sized picture](home/contrast2.png)

---
## How Contrast is Different from DAST

Traditional DAST tools try to exploit the running application with attacks, and detect vulnerabilities by analyzing HTTP responses. DAST, on the other hand, is blind to what occurs within the application and provides only limited coverage of an application. Contrast Assess performs a complete static analysis of all the code, as described above, and analyzes HTTP traffic and responses from inside the application. Because Contrast Assess works from within the application, it also provides more accurate analysis than traditional Penetration (Pen) Testing tools. Also, unlike either SAST or DAST products, Contrast Assess uses techniques found in Software Composition Analysis (SCA) tools to build an inventory of all the libraries, frameworks, and microservices used by the application to identify vulnerabilities across all those components.

---
## How Contrast is Different from SAST

Traditional SAST solutions attempt to build a model of an application and pseudo-execute it from known entry points – but SAST is blind to how all the pieces of an application work together and operate at runtime and can generate extensive false negatives and false positives. Contrast Assess observes real data and control flow activity from within a running application and identifies a much broader range of vulnerabilities – with greater accuracy – than traditional SAST solutions. Contrast Assess is fully distributed and infuses each application with a “self-assessment” capability that performs analysis continuously, in parallel, across an entire portfolio of applications. SAST solutions cannot operate in a distributed manner because they rely on experts to analyze and triage results, which creates a significant bottleneck.


---
### Your contrast_security.yaml file

In your workshop welcome email, your instructor will provide with a file named `contrast_security.yaml` that contains your API details.  This file has the following structure:

```yaml
api:
  url: https://eval.contrastsecurity.com/Contrast
  api_key: <YOUR_API_KEY>
  service_key: <YOUR_SERVICE_KEY>
  user_name: <YOUR_USER_NAME>
```

The four fields contain much of what you will be using in the next few pages.


This file is what your running applications use to authenticate with the server.  You are looking at this file to see how the agent we run uses the same details you will use in API requests.  Let's look at another page to see this information and more.


{{% /section %}}

