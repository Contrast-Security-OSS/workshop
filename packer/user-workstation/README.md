# Contrast Security Workshop Template

This repo contains the Packer template and Chef cookbooks to render a working workshop.

The rest of this documentation will change substantially.  To be continued...

The result of running is a virtual machine with these contents:

This repo includes a Packer template and Chef cookbooks that will build and pre-configure a Windows Server 2016  Azure VM image for Contrast Security demo purposes.  

- Windows Server 2016
- Chocolatey package manager
- Visual Studio 2017 Community Edition
- Visual Studio "ASP.NET and web development" feature
- Visual Studio ".NET desktop development" feature
- Visual Studio ".NET Core cross-platform development" feature
- "Contrast for Visual Studio" IDE plugin
- git
- Google Chrome
- 7-Zip
- Clone git repo eShopOnWeb (.NET Core) demo app
- Download pre-built WebGoat.NET demo app
- Download the Visual Studio project for the `net-flicks` .NET Core demo app
- Enable IIS and add an app pool and application for WebGoat.NET
- Configure the IIS Default Web Site and WebGoat.NET to be served via port 90
- Disable Internet Explorer Enhanced Security Configuration
- Install MySQL Server 5.7 and configure it for use with WebGoat.NET demo app
- Install Contrast Security .NET agent v19.6.3 (by default this will associate the .NET agent with the Contast Sales Engineers organization on `eval.contrastsecurity.com` using the `demo.person@contrastsecurity.com` user account)
- Install WebGoat7.1
- Install a vulnerable version of Spring PetClinic
- Install Juice Shop
- Install NodeGoat


TODO: delete references to TeamServer, which we will no longer include in this distribution.

## Origin story
The Packer template is forked from the excellent [Chef Bento project](https://github.com/chef/bento).  All Chef cookbook dependencies are included as a git submodule.  This Packer template will produce a Vagrant box that is compatible with VirtualBox and/or an Azure VM image that can launch as an Azure VM using the included Terraform plan.

## Building Boxes

### Requirements

This environment was tested withthe following:

- [Packer 1.5.6](https://www.packer.io/)
- [Azure CLI 2.2.0](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
- [Chef Workstation 0.18.3](https://downloads.chef.io/chef-workstation/)

### Initial checkout

You will need to check out this repository and update dependent submodules.  Start with this sequence to checkout and initialize submodules:

```
cd workshop (or the name of your repository)
git submodule init
git submodule update
cd cookbooks/contrast-windows-demo-workstation
git pull origin master
TODO: DELETE THE NEXT TWO LINES
cd ../chef-contrast-teamserver
git pull origin master
```


TODO: Remove this section about berks vendor within the teamserver section.

Next, run the `berks vendor` command to bring in dependencies:

```
cd cookbooks/chef-contrast-teamserver
berks vendor ..
```

### Using 'packer'

TODO: Delete the next section about the data bag, because we won't need it.

Next you will need to create a Chef encrypted data bag to store your Contrast Hub credentials.  

The embedded [`chef-contrast-teamserver` cookbook](https://github.com/Contrast-Security-OSS/chef-contrast-teamserver) requires credentials to log into Contrast Hub in order to download the target TeamServer installer, and utilizes the [encrypted data bag](https://docs.chef.io/secrets.html) to pass your Hub username and password to the target Chef-managed system.  You can create the encrypted data bag using Chef's `knife` utility.

Please note that this cookbook requires that the data bag be named `contrasthub` and the data bag items must be called `creds` with your Contrast Hub credentials named `username` and `password`.

First start by creating your secret key.  This file needs to be placed in a new directory in the root of your project named `data_bags`.  The commands you will run are:

Assuming you have OpenSSL, run these commands:
```
cd <your checkout directory>
mkdir data_bags
cd data_bags
openssl rand -base64 512 | tr -d '\r\n' > encrypted_data_bag_secret
```

Next, you will run a chef command to create a data bag named `contrasthub` and an entry named `creds`.  In order to be successful, you have to also specify an environment variable $EDITOR set to your preferred editor.  You can set this in the file `~/.chef/config.rb` with these contents:

```
knife[:editor] = "/usr/bin/vi"
```
or  
```
knife[:editor] = "notepad"
``` 
or your preferred editor.

Once you configure `$EDITOR`, you next run this command:

```
knife data bag create contrasthub creds --secret-file encrypted_data_bag_secret -z
```

`knife` will invoke your editor and you should fill in a body of the text file of this form:

```
"id": "creds",
"username": "brian.chau@contrastsecurity.com",
"password": "<your Contrast Hub password>"
```

When you save and exit, your newly encrypted data bag should now exist in your data_bags directory as a folder/file of tis format:

`data_bags/contrasthub/creds.json`

The contents of your creds.json file should be in this form:

```
%cat data_bags/contrasthub/creds.json
{
  "id": "creds",
  "username": {
    "encrypted_data": "6mynWeeJV3DVPlaRlYLoc/VAvVDyOxaS1MYdJ9TPQ2P6hyq8Vuu4mF7+XF0/\n57IsX60yQAM=\n",
    "iv": "lSLc7b+N0ng4J1wO\n",
    "auth_tag": "PfJSettBwtH4lD8ukFadCg==\n",
    "version": 3,
    "cipher": "aes-256-gcm"
  },
  "password": {
    "encrypted_data": "mu6Zubm4VzlLF3ecU2p/Il5COmwChQaKJoriHg==\n",
    "iv": "FQrp9++e9mhq5ecO\n",
    "auth_tag": "MwG6kTKpuO1c4v+doOTcKg==\n",
    "version": 3,
    "cipher": "aes-256-gcm"
  }
```

Additional commands you may want to use to test the presence of your data bag are:

```
cd <github folder>/data_bags
knife data bag list -z
knife data bag show contrasthub -z
knife data bag show contrasthub creds -z -secret-file encrypted_data_bag

```

For more information about using encrypted data bags and more, please watch this nice video: https://youtu.be/y4ZAVafd1RI.


Then run Packer to build the VM images:

```
$ packer build -force -only azure-arm 2016.json
```

OR 

```
$ packer build -force 2016.json
```

Please note that the image can take up to 3 hours to build.

# TODO : Revise contents below this line

## Using 'terraform' to launch an Azure VM demo workstation
You must first edit the `variables.tf` file to define the values for the `initials` and `location` variables.  For example:

```
variable "initials" {
  description = "Enter your initials to include in URLs. Lowercase only!!!"
  default = "bc"
}

variable "location" {
  description = "The Azure location where all resources in this example should be created, to find your nearest run `az account list-locations -o table`"
  default = "westus"
}
...
```

Then create a new Azure VM based on the Packer-produced image.  First run `terraform plan` to ensure there are not issues, then run the following:

```
$ terraform apply -auto-approve
```

Once Terraform finished provisioning the new Azure VM, an IP address will be provided as part of the Terraform output.  Copy the the IP address and connect to the Azure VM using Microsoft Remote Desktop.

The default login credentials are provided at the end of the Terraform output.

There is currently an issue with the Azure VM build where the Contrast IDE plugin for Visual Studio does not get installed.  **Therefore, please run `"C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\IDE\VSIXInstaller.exe" /skuName:Community /skuVersion:15.0 /quiet /force "C:\Contrast\contrast-visual-studio-extension.vsix"` from the command prompt to install the IDE plugin.**  This is also mentioned below.

Terraform does not provide a means to "suspend" or "stop" an Azure VM, so you will need to do so by running the following Azure CLI command from a terminal to shutdown, but not delete, your VM when not needed (the `deallocate` (versus `stop`) command will stop and deprovision VM resources to help save on costs):

```
$ az vm deallocate --resource-group Sales-Engineer-<your initials> --name hde-win2016-vm-<your initials>
```

To start the VM again, you can use the following commands to restart and get its public IP address:

```
$ az vm start --resource-group Sales-Engineer-<your initials> --name hde-win2016-vm-<your initials>; az vm show --resource-group Sales-Engineer-<your initials> --name hde-win2016-vm-<your initials> -d | grep public
```

Or you can stop and start the VM from the Azure Portal.  Login to the Azure Portal and look for a virtual machine named `hde-win2016-vm-<your initials>`.

However, if you are done using the Azure VM, you can destroy the VM instance with `terraform destroy -force`.


## Additional manual setup required after Chef configuration

Unfortunately, at the time of the Chef cookbook's creation, there was no way to automate certain tasks that are necessary to get this Contrast Windows demo workstation fully ready for demonstrations.  The following setup steps will need to be done after a Chef run:

- Launch Visual Studio and login (e.g., sign in as the `demo.person@contrastsecurity.com` user)
- **If using the Azure VM, there is an issue where Contrast IDE plugin for Visual Studio does not get installed; therefore, please run `"C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\IDE\VSIXInstaller.exe" /skuName:Community /skuVersion:15.0 /quiet /force "C:\Contrast\contrast-visual-studio-extension.vsix"` from the command prompt to install the IDE plugin**
- Configure the connection settings for the Contrast Visual Studio plugin to point to your personal `eval.contrastsecurity.com` organization or whichever TeamServer organization you wish
- Ensure that the Contrast .NET Agent and Agent Tray is started

Additional optional post-Chef run configuration can include:

- Updating the Contrast .NET Agent YAML configuration file to use your personal API and authentication keys and restarting the .NET Agent (by default the .NET agent sends data to the `Contrast Sales Engineers` organization on `eval.contrastsecurity.com`)
- Starting Google Chrome and setting it as the default browser
- Pinning the following applications to the Windows taskbar
  - Google Chrome
  - Visual Studio
