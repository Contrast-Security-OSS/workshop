+++
title = "Module 6: Introduction to Open Source"
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

{{% /note %}}
# Module 6: Introduction to Open Souce

Jump to:
- [Module Introduction](#/module-introduction)
- [What is Open Source and what is Open Source Software?](#/what-is-oss)
- [What are the business risks associated with FOSS?](#/oss-business-risks)
- [How to identify OSS libraries with Contrast?](#/oss)
- [How to identify OSS legal and operational risks with Contrast?](#/oss-legal-ops-risks)
- [Advanced features of Contrast OSS product](#/advanced-features)

---
{{< slide id="module-introduction" >}}
## Module Introduction

In this module you will learn what is Open Source, what are the common business risks associated with Open Source and how you can solve those with business risks.

`Disclaimer: I am not a lawyer and no information in this module is a legal advice`

---
{{< slide template="info" >}}
# Time and Prerequisites
This Module should take about 40 minutes to complete.

Be sure to have completed the [prerequisites](../#/2)

---
## Objectives

Contrast Security is providing this module as a high level overview of some of the issues which are associated with Free and Open Source Software (FOSS).

- Learn what is considered Open Source and Open Source Software (OSS) aka FOSS
- Learn what business risks are associated with FOSS
- Learn how to mitigate those risks with Contrast
- Learn advanced features provided by Contrast to improve quality of your FOSS

---
{{< slide id="what-is-oss" >}}
## What is Open Source and what is Open Source Software?

The term Open Source refers to anything that people can modify and share because it’s design is publicly available.

The Open-Source Software or OSS (also sometimes referred to as Free and Open-Source Software or FOSS) refers to any software with source code that anyone can inspect, modify and enhance.

An integral part of Open Source Software is presence of a license.

Without a license a piece of source code is not an Open Source Software, in fact it can be anything e.g. stolen commercial code. In fact physical source code in public access does not make it Open Source.

Typically an Open Source License declares that source code in question is available to others who would like to view that code, copy it, learn from it, alter it, or share it.


See more: https://opensource.com/resources/what-open-source

---
{{< slide id="oss-business-risks" >}}
### What are the business risks associated with FOSS?

Three classes of risk associated with FOSS are legal and security risks.

* Security risk is coming from publicly known vulnerabilities present in FOSS libraries as well as zero-day vulnerabilities
* Legal risk originates from licenses which effectively declare terms of use of any given FOSS. Be mindful that absence of a license means that terms of use are unknown and hence represent even greater risk to the business.
* Operational risk - which is coming from the old or obsolete FOSS components which are no longer maintained and potentially have multiple zero day vulnerabilities which outside of the public eye due to low popularity of these components or older versions of some of the more popular components


Contrast Security OSS product can help you manage all of these risks.



---
{{< slide id="oss" >}}
### How to identify OSS libraries with Contrast?
{{% note %}}

{{% /note %}}

First thing you need is an instrumented application. You can take any application you have used in previous modules or onboard a new one, e.g. https://github.com/terracotta-bank/terracotta-bank

Once application is on-boarded the list of libraries in such application is populated immediately and you can go to `Applications > [App Name] > Libraries`

{{< figure src="libraries-tab.png" height="400px">}}


---
### Contrast OSS panel overvew
On the screen shot on previous slide you can find information about the library score (from A to F, where A is best and F is worst) library name, version you are using now (with release date), latest version (also with release date) and class usage information.

Contrast scores libraries based three factors: time, status, security

You can read more on library scoring here: https://docs.contrastsecurity.com/en/library-scoring-guide.html

---
### How to find information about publicly known security vulnerabilities in OSS you use?

First click on the funnel next to the "Usage" column title and tick against "Used"
{{< figure src="filter-used.png" height="150px">}}

Then click on vulnerabilities drop down list which is on the left
{{< figure src="vuln-ddl.png" height="150px">}}

and choose "Vulnerable", this will produce the list of libraries that contain publicly known security vulnerabilities
{{< figure src="vuln-ddl-expanded.png" height="150px">}}

---
### Detailed security information about the library
If you click on the library name you will get to a library page where you can find information on which applications are using this library, on which servers those applications are hosted, various other metadata and most importantly information about publicly known security vulnerabilities:

{{< figure src="detailed-library-info.png" height="450px">}}

---
{{< slide id="oss-legal-ops-risks" >}}
### How to identify OSS legal risks with Contrast?

In very broad terms legal risk originates from those license obligations which are unknown to your business and prevent from licensing your code with terms that satisfy your business model.

In order to see what licenses were identified in our application click filter icon on the top and expand the list of licenses that are necessary

{{< figure src="licenses.png" height="350px"
caption="[See the full-sized picture](licenses.png)">}}

You can see what you can, can not and must do for every OSS license here: https://tldrlegal.com/

---
###  How to identify OSS operational risks with Contrast?

On the main "Library" tab release dates will help you quickly understand which libraries are out of date.

Aside from this: on the top right corner of the Library tab clock "Show Library Status"
{{< figure src="show-library-status.png" height="94px">}}

You will find graph similar to the one below depicting the age of the libraries that have been identified
{{< figure src="operational-status.png" height="400px">}}

---
{{< slide id="advanced-features" >}}
## Advanced features of Contrast OSS product

Contrast provides you with information about the number of classes loaded during execution of our application as well as list of loaded class names.

This information will help developers prioritise the remediation work (e.g. it makes sense to focus on the most used library with largest number of vulnerabilities) or for example estimate the coverage of their applications.

To bring enhanced class usage data simply click on the number in "Usage" column and you will be presented with the following view
{{< figure src="ecu-list.png" height="300px">}}

Go back to the [module list](../#/module-list)  
