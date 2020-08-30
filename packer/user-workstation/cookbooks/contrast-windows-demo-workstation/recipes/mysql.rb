#
# Cookbook:: contrast-windows-demo-workstation
# Recipe:: mysql
#
# Copyright:: 2019, The Authors, All Rights Reserved.

# Download MySQL Server 5.7
remote_file 'C:\Contrast\mysql-5.7.26-winx64.zip' do
  source 'https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.26-winx64.zip'
  checksum '7560341a5ed58fd6297886ca81dbbb16098fb8befaf4b5bec52db4ea1e64afc7'
  rights :full_control, 'Everyone'
  action :create
end

# Unarchive the MySQL Server zip
seven_zip_archive 'Extract MySQL Server from zip archive' do
  path 'C:\Program Files\MySQL'
  source 'C:\Contrast\mysql-5.7.26-winx64.zip'
  overwrite true
  action :extract
  not_if { ::File.exist?('C:\Program Files\MySQL\mysql-5.7.26-winx64\bin\mysqld.exe') }
end

# Initialize the database
execute 'Initialize the MySQL Server database' do
  command 'mysqld --initialize-insecure'
  cwd 'C:\Program Files\MySQL\mysql-5.7.26-winx64\bin'
  action :run
  not_if { ::Dir.exist?('C:\Program Files\MySQL\mysql-5.7.26-winx64\data') }
end

# Create the MySQL Server Windows service
execute 'Setup the Windows service for MySQL Server' do
  command 'mysqld --install'
  cwd 'C:\Program Files\MySQL\mysql-5.7.26-winx64\bin'
  action :run
end

# Start the MySQL Server Windows service
windows_service 'Start MySQL Server' do
  service_name 'MySQL'
  action :start
end
