#
# Cookbook:: contrast-windows-demo-workstation
# Recipe:: contrastdemo
#
# Copyright:: 2019, The Authors, All Rights Reserved.

# Download a pre-built WebGoat.NET demo app
remote_file 'C:\Contrast\WebGoat.zip' do
 source 'https://contrastsecurity.box.com/shared/static/216i9gw46umhwk1i4f8s12fd97reave3.zip'
 rights :full_control, 'Everyone'
 action :create
end

# Extract the WebGoat.NET demo app
seven_zip_archive 'Extract WebGoat.NET demo app from zip archive' do
 path 'C:\Contrast'
 source 'C:\Contrast\WebGoat.zip'
 overwrite true
 action :extract
end

# Download pre-built DotNetFlicks .NET Core demo app
remote_file 'C:\Contrast\DotNetFlicks.zip' do
 source 'https://contrastsecurity.box.com/shared/static/gzg3o80c2s44bzbjzb9m7lvf6f31l4t9.zip'
 rights :full_control, 'Everyone'
 action :create
end

# Extract the DoNetFlicks demo app
seven_zip_archive 'Extract .NET Flicks demo app from zip archive' do
 path 'C:\Contrast'
 source 'C:\Contrast\DotNetFlicks.zip'
 overwrite true
 action :extract
end

# Install Contrast Security .NET agent
# Get the .NET agent installer archive specified by the 'dotnet_agent_archive' cookbook attribute
cookbook_file "C:\\Contrast\\#{node['contrast-windows-demo-workstation']['dotnet_agent_archive']}" do
  source node['contrast-windows-demo-workstation']['dotnet_agent_archive']
  rights :full_control, 'Everyone'
  action :create
end

# Extract the .NET agent installer from the archive
seven_zip_archive 'Extract Contrast .NET agent installer from zip archive' do
  path 'C:\Contrast'
  source "C:\\Contrast\\#{node['contrast-windows-demo-workstation']['dotnet_agent_archive']}"
  overwrite true
  action :extract
end

# Execute a silent installation of the Contrast .NET agent
execute 'Install Contrast Security .NET agent' do
  command 'ContrastSetup.exe -s -norestart PathToYaml="C:\Program Files\Contrast\dotnet\contrast_security.yaml"'
  cwd 'C:\Contrast'
  action :nothing
end

# Create default Contrast .NET agent installation directory
directory 'C:\Program Files\Contrast\dotnet' do
  rights :full_control, 'Everyone'
  recursive true
  action :create
end

# Get the Contrast agent YAML configuration file
template 'C:\Program Files\Contrast\dotnet\contrast_security.yaml' do
  source 'contrast_security_dotnet.yaml.erb'
  rights :full_control, 'Everyone'
  action :create
  sensitive true
  notifies :run, 'execute[Install Contrast Security .NET agent]', :immediately
end

# Create a new MySQL database for WebGoat.NET
execute 'Create MySQL database for WebGoat.NET' do
 command '"C:\Program Files\MySQL\mysql-5.7.26-winx64\bin\mysql.exe" -u root -e "create database if not exists webgoat_coins;"'
 cwd "#{node['contrast-windows-demo-workstation']['webgoat_path']}\\DB_Scripts"
 # ignore_failure true # Need to ignore failures when running the MySQL configuration script because the WebGoat.NET scripts generate errors
 action :run
end

# Create the new `webgoat_coins` database tables
execute 'Create MySQL database tables for WebGoat.NET' do
 command '"C:\Program Files\MySQL\mysql-5.7.26-winx64\bin\mysql.exe" -u root -e "use webgoat_coins; source create_webgoatcoins.sql;"'
 cwd "#{node['contrast-windows-demo-workstation']['webgoat_path']}\\DB_Scripts"
 ignore_failure true # Need to ignore failures when running the MySQL configuration script because the WebGoat.NET scripts generate errors
 action :run
end

# Configure and load the WebGoat.NET data into the MySQL database
execute 'Configure MySQL database for WebGoat.NET' do
 command '"C:\Program Files\MySQL\mysql-5.7.26-winx64\bin\mysql.exe" -u root -e "use webgoat_coins; source load_webgoatcoins.sql;"'
 cwd "#{node['contrast-windows-demo-workstation']['webgoat_path']}\\DB_Scripts"
 ignore_failure true # Need to ignore failures when running the MySQL configuration script because the WebGoat.NET scripts generate errors
 action :run
end

# Try to install the 'Contrast for Visual Studio' IDE plugin again since it doesn't always work
execute 'Install Contrast for Visual Studio extension' do
  command 'VSIXInstaller.exe /skuName:Community /skuVersion:15.0 /quiet /force "C:\Contrast\contrast-visual-studio-extension.vsix"'
  cwd 'C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\IDE'
  retries 2
  retry_delay 3
  action :run
end
