# Eval Provisioning Scripts

The purpose of these scripts is to automatically set up organisations in the eval environment for everyone who attends the workshop. It consists of two main scripts to create and delete organisations:

* create-orgs.sh
* delete-orgs.sh

# Pre-requisites

TeamServer EOP 3.7.5 or higher or https://eval.contrastsecurity.com/.  

The script relies on jq, available from https://stedolan.github.io/jq/download/.

- Mac install with brew: `brew install jq`
- Linux has apt-get, dnf, zypper, pacman options
- Windows has Chocolatey and binary download options.

# Setup

You need to supply a Contrast Server API Key, Authorization header, and default Admin password. 

- The recommended invocation is to supply the command-line arguments for these values.  Call the scripts with the `-h` option to see the format.
    - Options are for the API Key, Authorization Header, URL, and Password.
    - Some options have defaults and do not need to be specified.

- The alternate invocation is to modify the script
    - Populate the variables at the top of **both** scripts with your superadmin credentials (all SEs should be superadmin on eval): `CONTRAST_SE_API_KEY` and `CONTRAST_SE_AUTH_HEADER`

    - Populate the `ADMIN_PASSWORD` variable at the top of the `create-orgs.sh` script with a suitably complex password (which meets the TeamServer complexity requirements).

# Creating Organisations

You can choose to automatically create X number of numbered user accounts or manually enter users and email addresses into the `users.csv` file. All organisations which were successfully created will be stored within the `orgs-created.csv` file so that they can be deleted after the workshop.

You can also specify the name of the csv file to override the default.

### Create Numbered Users

- Run `./create-orgs.sh` and select option 1 when prompted. Enter a number between 1 and 50.  

### Create Named Users

- Populate the users.csv file with your users, they should be in the following format:

    ```
    first,last,email
    David,Archer,david.archer@contrastsecurity.com
    ```
   
   NOTE: Email addresses must be unique

- Run `./create-orgs.sh` and select option 2 when prompted. 

## Deleting Organisations

- Run `./delete-orgs.sh` and it will list all of the organisations which were created from running the create script and prompt to confirm that you would like to delete them.  

