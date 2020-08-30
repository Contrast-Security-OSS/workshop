# Workshop presentation files

The contents of this folder are the slides and materials for user students to test Contrast Security.  We are using Hugo for Static Site Generation (SSG) of our presentation files, and this folder contains the presentation materials "as-code."

Inspiration came from both [Reveal JS](https://revealjs.com/#/) and [Hugo](https://gohugo.io/).

See also https://github.com/hakimel/reveal.js



## Prerequisites

This site assumes the following:
- Hugo version 0.74.2
- Reveal for Hugo installed into your templates folder.

The best advice to install Hugo is from the providers site at https://gohugo.io/getting-started/quick-start/.
Reveal for Hugo is at https://github.com/dzello/reveal-hugo.

See also https://themes.gohugo.io/reveal-hugo/


## Usage - local

The usage is simple enough!

From a clean checkout, you should be able to run the following:

```
cd reveal-hugo
hugo server
```

The default is to run on localhost with port 1313 as `http://localhost:1313/`.  You can override the port and other options by specifying the `-p` option:

```
cd reveal-hugo
hugo server -p 1234
```

The location of your files is defined by the file `config.toml` which has these assignments:

```toml
baseURL = "/"
publishDir = "local"
```

The `baseURL` identifies the pathing we need for our local serving, and we're advised to use the `/`

The publishDir contains the static files we generate locally.  We do not need to check those in.


## Usage - build for production

There are multiple ways to deploy Hugo content.

We're using Github Pages and not Bitbucket because it is easier.

See the instructions at https://gohugo.io/hosting-and-deployment/, and note how BitBucket requires a third-part hosting option.  The decision here is to utilize Github instead.

Looking through the instructions at https://gohugo.io/hosting-and-deployment/hosting-on-github/, we're using a second repository as the target of our output files.  This is because GitHub pages work from the master directory or master/docs, and our presentation is in a nested folder.  The target repository is:
 
https://github.com/Contrast-Security-OSS/workshop-hugo
 
 The instructions to build the content are simple, and follow the scripting mentioned in the instructions.  
 
 Start by checking out this repository, and then checking out https://github.com/Contrast-Security-OSS/workshop-hugo as a submodule:
 
 ```
git clone https://github.com/Contrast-Security-OSS/workshop.git
cd workshop
git submodule add -b master https://github.com/Contrast-Security-OSS/workshop-hugo public
``` 
Once checked-out, you can build the files, commit them, and the website should be updated as a result.  Note we're using a "production" TOML file that contains the baseURL of the GitHub repo:

```
hugo --config config.prod.toml
cd public
git add *
git commit -m "rebuild for a nice reason"
git push origin master
```
 
## Publishing to GitHub Pages

Hugo generates static pages, and we enabled GitHub Pages on this repository: https://github.com/Contrast-Security-OSS/workshop-hugo

The requirements to host the page are short:
1. Public repository
2. Enable Github Pages on the repository
3. Select the appropriate branch (master) and working folder.

The root-level `index.html` is enough to make this work.

To publish new pages, follow these steps.

- Checkout https://github.com/Contrast-Security-OSS/workshop
- cd to the presentation/reveal-hugo folder

The file `config.prod.html` contains a reference to the GitHub Pages URL, which we have to use when we post to Github.  Locally, we use plain-old `config.html` with a reference usable by running locally.

- Run this command to publish the files to the `public folder`
`hugo --config config.prod.html`

- cd to the public folder and run the commands to publish.
```
cd public
git add *
git commit -m "your checking message"
git push origin master
```

- It's a good idea to also add the updated reference to the public submodule in this repository.

## TODO

- Validate the largely linear presentation model in Modules 1-4
- Consider additional modules, driven by demand
  - .NET
  - .NET Core
  - Visual Studio
  - Other agents
  - Kubernetes
  - Azure
  - AWS (Fargate)
  - TeamServer administration (policies, licenses, etc.)

## History and other data points

Previous tests included Hugo 0.74, 0.73, 0.70 and 0.69.

Hugo is updated frequently, and worth checking for the latest versions.  Hugo documentation is mostly okay.  Some details are well covered, and others are about SMOP (Simple matter of programming).  Reference examples are light.

Tested with Windows and Ubuntu 18.04 LTS, and MacOS (chocolatey, apt, brew).  On any platform, you may have to adjust firewall rules to allow local access to the default port 1313, or access from external computers to your host.
