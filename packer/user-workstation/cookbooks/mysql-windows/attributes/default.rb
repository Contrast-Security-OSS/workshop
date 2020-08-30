# passwords
default['mysql']['server_root_password'] = 'replace_me'

# port
default['mysql']['port'] = '3306'

# version
default['mysql']['version'] = '5.5.43'

# Source URL of Mysql Server

case node['kernel']['machine']
when 'x86_64'
	default['mysql']['windows']['url'] = "http://cdn.mysql.com/Downloads/MySQL-5.5/mysql-#{node['mysql']['version']}-winx64.msi"
when 'i386'
	default['mysql']['windows']['url'] = "http://cdn.mysql.com/Downloads/MySQL-5.5/mysql-#{node['mysql']['version']}-win32.msi"
end

default['mysql']['windows']['dir'] = "C:\\Mysql"

# MySQL Instance Configuration

default['mysql']['windows']['AddBinToPath'] = 'no' # accepted values {yes | no}
default['mysql']['windows']['ServerType'] = 'DEVELOPMENT' # accepted values {DEVELOPMENT | SERVER | DEDICATED}
default['mysql']['windows']['DatabaseType'] = 'MIXED' # accepted values {MIXED | INNODB | MYISAM}
default['mysql']['windows']['ConnectionUsage'] = 'DSS' # accepted values {DSS | OLTP}
default['mysql']['windows']['SkipNetworking'] = 'yes' # accepted values {yes | no}. Specifying yes disables network access altogether
default['mysql']['windows']['StrictMode'] = 'yes' # accepted values {yes | no}
