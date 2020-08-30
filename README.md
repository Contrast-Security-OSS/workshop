# Workshop #

This public repository contains assets from Contrast Security to publish workshops for external users.  These workshops are part of a guided and (eventually) self-directed workshops to help people become better acquainted with Contrast Security and Security concepts in general.

Contrast Security intends to deliver the contents of this workshop starting in 2020.

## Operating Environment
This workshop series is designed to be run with these considerations:
* Instructor-led.  The current set of modules assume an instructor.  Future modules will include self-service.
* Hosted Teamserver.  The modules assume https://eval.contrastsecurity.com/Contrast
* EOP. The modules were also developed and tested on EOP 3.7.6
* Contrast Security provides hosted Windows Workstations that include relevant tooling 
* Tooling - when self-service is enabled, here are some of the relevant tools you can leverage:
    * Works with Windows, Ubuntu 18.04, and MacOS
    * Git 2.16+
    * General preference for bash
    * python 3.6+
    * maven 3.6.3+

### Contents ###

This repository contains the following items, each described within their subdirectories.

* apps - setup vulnerable applications for end users
* eval-provisioning - configures the server with new users
* packer - scripts to build a VM for workshop attendees.
* presentation - documentation for facilitators
* jenkins - setup CI server with users and infratructure for a workshop



TBD
* Setup scripts to provision users, infrastructure, and VMs for workshop classes.

