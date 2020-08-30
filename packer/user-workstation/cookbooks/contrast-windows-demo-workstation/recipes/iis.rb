#
# Cookbook:: contrast-windows-demo-workstation
# Recipe:: iis
#
# Copyright:: 2019, The Authors, All Rights Reserved.

# Install IIS
include_recipe 'iis::default'

windows_feature ['Web-Asp-Net45'] do
  action :install
  install_method :windows_feature_powershell
end

# Configure IIS `Default Web Site` to run on port 90
iis_site 'Default Web Site' do
  port 90
  action :config
end

# Create a new app pool for WebGoat.NET
iis_pool 'WebGoat' do
  runtime_version '4.0'
  pipeline_mode :Integrated
  action :add
end

# Create a new application for WebGoat.NET
iis_app 'webgoat-net' do
  site_name 'Default Web Site'
  path '/webgoat-net'
  application_pool 'WebGoat'
  physical_path node['contrast-windows-demo-workstation']['webgoat_path']
  enabled_protocols 'http,net.pipe,net.tcp'
  action :add
end
