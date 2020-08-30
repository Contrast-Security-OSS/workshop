# contrast-windows-demo-workstation

This Chef cookbook will configure a Windows 2016 system with software and tools necessary to deliver a Microsoft-centric Contrast Security demo.  This cookbook has been tested against an Azure VM and a Vagrant box running Windows Server 2016.

The following will be installed or configured on the system:

* Chocolatey package manager
* Visual Studio 2017 Community Edition
* Visual Studio "ASP.NET and web development" feature
* Visual Studio ".NET desktop development" feature
* Visual Studio ".NET Core cross-platform development" feature
* "Contrast for Visual Studio" IDE plugin
* ~~Docker Engine~~ (Can easily be added back)
* git
* Google Chrome
* 7-Zip
* Clone git repo eShopOnWeb (.NET Core) demo app
* Download pre-built WebGoat.NET demo app
* Enable IIS and add an app pool and application for WebGoat.NET
* Disable Internet Explorer Enhanced Security Configuration
* Install MySQL Server 5.7 and configure it for use with WebGoat.NET demo app
* Install Contrast Security .NET agent v19.6.1 (by default this will associate the .NET agent with the Contast Sales Engineers organization on `eval.contrastsecurity.com` using the `demo.person@contrastsecurity.com` user account)
* ~~Microsoft Teams~~ (Can easily be added back)

## Additional manual setup required after Chef configuration

Unfortunately, at the time of this Chef cookbook's creation, there was no way to automate certain tasks that are necessary to get this Contrast Windows demo workstation fully ready for demonstrations.  The following setup steps will need to be done after a Chef run:

* Launch Visual Studio and login (e.g., sign in as the `demo.person@contrastsecurity.com` user)
* ~~Launch Microsoft Teams and login (e.g., sign in as the `demo.person@contrastsecurity.com` user)~~

Additional optional post-Chef run configuration can include:

* Starting Google Chrome and setting it as the default browser
* Pinning the following applications to the Windows taskbar
  * Google Chrome
  * Visual Studio
  * ~~Microsoft Teams~~

## Requirements

### Supported Platforms

* Windows Server 2016

### Cookbooks

* windows
* seven_zip
* chrome
* chocolatey
* iis
* git
* ms_dotnet
* vcruntime
* mysql-windows
  