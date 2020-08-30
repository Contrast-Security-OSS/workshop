# Jenkins Provisioning Scripts

The purpose of these scripts is to more automatically setup users in a Jenkins instance for the workshop.

* create-jenkins-students.sh
* TBD: delete-jenkins-students.sh

# Pre-requisites

- Jenkins 2.190.2 or higher.
- bash

# Setup

You need to supply the Jenkins URL, an admin Username and Password, and an input file of student-users.

- The recommended invocation is to supply the command-line arguments for these values.  Call the scripts with the `-h` option to see the format.
    - Options are to specify the Jenkins login and URL, plus the lists of students.
    - Some options have defaults and do not need to be specified.

### Create Named Users

This Jenkins setup uses the same format as other parts of the workshop.

- Populate the users.csv file with your users, they should be in the following format:

    ```
    first,last,email
    David,Archer,david.archer@contrastsecurity.com
    ```
   
   NOTE: Email addresses must be unique, and they will be the login username.

- Run `./create-jenkins-students.sh` and select option 2 when prompted. 

## Deleting student-users

This is TBD

- Run `./delete-jenkins-students.sh` with similar input parameters to remove users.

