+++
title = "Contrast Security Community Edition"
chapter = true
weight = 20
outputs = ["Reveal"]
+++

{{% section %}}
# Community Edition - optional

*You will be directed to configure a Community Edition account only if necessary.*

The Contrast CE is a free application security platform for Java and .NET Core web applications or APIs (other languages coming soon).

The CE offering is for self-directed workshops where there is no instructor.  The registration URL is https://www.contrastsecurity.com/community-edition-lp-website

Self-directed workshop modules will identify when you can use the CE instance of TeamServer.


---
### Create your account

1. If you don't have a Contrast CE account, [create one now] (https://www.contrastsecurity.com/community-edition-lp-website)

---
### Get your configuration file - step 1
After logging in, click the +Add Agent button in the top right

{{< figure src="home/ce_1.png" style="border: 1px solid #000;" height="500px">}}
[See the full-sized picture](home/ce_1.png)

---
### Get your configuration file - step 2
3. Go to the second step:
{{< figure src="home/ce_2.png" style="border: 1px solid #000;" height="500px">}}
[See the full-sized picture](home/ce_2.png)

---
### Get your configuration file - step 3

4. Download the config file as directed below  The configuration file is named `contrast_security.yaml` and contains the essential details applications need to communicate with your server. Each user has a configuration file with details specific to their instance and users can extend or override default values to enhance the integration into Contrast Security. We'll cover some of those enhancements later.

{{< figure src="home/ce_3.png" style="border: 1px solid #000;" height="500px">}}
[See the full-sized picture](home/ce_3.png)

---
## Clone the source repository for this workshop

Now we want to clone the repository that contains all the content and files you need to complete this workshop.  For the purposes of the workshop, your working directory is `~/workshop` and the code repository, builds, and command-line activities will occur within this folder.  This mirrors how most users operate with their code when developing.

On Linux/MacOS:
```bash
cd ~/
mkdir workshop
cd workshop
git clone https://github.com/Contrast-Security-OSS/workshop.git
```

On Windows:
```
cd $HOMEPATH
mkdir workshop
cd workshop
git clone https://github.com/Contrast-Security-OSS/workshop.git
```

{{% /section %}}
