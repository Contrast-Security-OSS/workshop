#
# Cookbook:: contrast-windows-demo-workstation
# Recipe:: msteams
#
# Copyright:: 2019, The Authors, All Rights Reserved.

# Install Microsoft Teams
chocolatey_package 'microsoft-teams' do
  action :install
end
