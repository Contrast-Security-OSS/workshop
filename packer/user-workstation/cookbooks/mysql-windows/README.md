MySQL cookbook
=====================

The MySQL cookbook exposes the `mysql-windows::default` and `mysql-windows::uninstall` recipes.

Scope
-----
This cookbook is concerned with the "MySQL Community Server".

This cookbook does not try to encompass most of the configuration
option available for MySQL.

Requirements
------------
* Chef 11 or higher
* Ruby 1.9 (preferably from the Chef full-stack installer)

Recipes
-------
### mysql-windows::default

This recipe installs a Mysql Server and configure the MySQL Instance as a service. Instance 
configuration parameters as passed from node attributes.

### mysql-windows::uninstall

This recipe removes the MySQL instance service and uninstall the MySQL server.
Assuming that mysql was installed using the same cookbook.

Usage
-----

### run_list

Include `'recipe[mysql-windows]'` or `'recipe[mysql-windows::uinstall]'` in your run_list.


Attributes
----------

### password
default['mysql']['server_root_password'] = 'ilikerandompasswords'

### port
default['mysql']['port'] = '3306'

### Source URL of Mysql Server
default['mysql']['windows']['url'] = 'URL'

default['mysql']['windows']['dir'] = "C:\\Mysql"

### MySQL Instance Configuration

default['mysql']['windows']['AddBinToPath'] = 'no' # accepted values {yes | no}

default['mysql']['windows']['ServerType'] = 'DEVELOPMENT' # accepted values {DEVELOPMENT | SERVER | DEDICATED}

default['mysql']['windows']['DatabaseType'] = 'MIXED' # accepted values {MIXED | INNODB | MYISAM}

default['mysql']['windows']['ConnectionUsage'] = 'DSS' # accepted values {DSS | OLTP}

default['mysql']['windows']['SkipNetworking'] = 'yes' # accepted values {yes | no}. Specifying yes disables network access altogether

default['mysql']['windows']['StrictMode'] = 'yes' # accepted values {yes | no}

License & Authors
-----------------
- Author:: Deepak Sihag (<sihag.deepak@gmail.com>)

