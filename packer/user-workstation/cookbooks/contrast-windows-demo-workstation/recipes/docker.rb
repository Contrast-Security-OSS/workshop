#
# Cookbook:: contrast-windows-demo-workstation
# Recipe:: docker
#
# Copyright:: 2019, The Authors, All Rights Reserved.

# Install the Windows-native Docker Engine only (no Docker Desktop for Windows)
powershell_script 'Install Docker Engine' do
  code <<-EOH
  Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
  Install-Module -Name DockerMsftProvider -Force
  Install-Package -Name docker -ProviderName DockerMsftProvider -Force
  EOH
  not_if { ::File.exist?('C:\Program Files\Docker\docker.exe') }
  notifies :request_reboot, 'reboot[Restart Computer]', :immediately
end
