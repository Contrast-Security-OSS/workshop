#
# Cookbook Name:: mysql-windows
# Recipe:: uninstall
#

# removing Mysql Service

powershell_script "MySQL Configure Wizard" do
  code <<-EOH
     #{node['mysql']['windows']['dir']}\\bin\\MySQLInstanceConfig.exe -r ServiceName=MySQL
  EOH
end

# Uninstalling MySQL
uninstaller = node['mysql']['windows']['url'].split('/').last

remote_file "#{Chef::Config[:file_cache_path]}\\#{uninstaller}" do
	source node['mysql']['windows']['url']
end

command = "msiexec /x #{Chef::Config[:file_cache_path]}\\#{uninstaller} /quiet"

powershell_script "Uninstalling MySQL" do
  code <<-EOH
     #{command}
  EOH
end
