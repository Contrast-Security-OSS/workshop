#
# Cookbook Name:: mysql-windows
# Recipe:: default
#


#Installing Mysql Server
windows_package "MySQL Server"  do
	installer_type :msi
	source node['mysql']['windows']['url']
	options %W[
    /quiet
    INSTALLDIR="#{node['mysql']['windows']['dir']}"
  ].join(' ')
end

# Creating and starting MySQL as a windows service
powershell_script "MySQL Configure Wizard" do
  code <<-EOH
     #{node['mysql']['windows']['dir']}\\bin\\MySQLInstanceConfig.exe -i -q "-lC:\\mysql_install_log.txt" »  "-nMySQL Server 5.5" "-p#{node['mysql']['windows']['dir']}" -v5.1.73 »  "-t#{node['mysql']['windows']['dir']}\\my-template.ini" "-c#{node['mysql']['windows']['dir']}\\my.ini" ServerType=#{node['mysql']['windows']['ServerType']} DatabaseType=#{node['mysql']['windows']['DatabaseType']} »   ConnectionUsage=#{node['mysql']['windows']['ConnectionUsage']} Port=#{node['mysql']['port']} ServiceName=MySQL RootPassword=#{node['mysql']['server_root_password']} AddBinToPath=#{node['mysql']['windows']['AddBinToPath']} SkipNetworking=#{node['mysql']['windows']['SkipNetworking']} StrictMode=#{node['mysql']['windows']['StrictMode']}
  EOH
end
