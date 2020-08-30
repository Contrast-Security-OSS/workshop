#
# Cookbook:: contrast-windows-demo-workstation
# Recipe:: base
#
# Copyright:: 2019, The Authors, All Rights Reserved.

# Set a static hostname which will also be used with the associated Terraform plan
hostname 'workshop-vm' do
  windows_reboot false
  action :set
end

# Install the 7zip utility
include_recipe 'seven_zip::default'

# Install Google Chrome (for convenience instead of using IE)
include_recipe 'chrome::default'
# remote_file 'C:\Users\azure\AppData\Local\Temp\kitchen\cache\package\googlechromestandaloneenterprise64.msi' do
#   source 'https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D'\
#   '%26iid%3D%7B189AD26E-9E1F-286E-A24B-8676A4F84AE2%7D%26lang%3Den%26browser%3D4%26usagestats%3D0%26appname%3DGoogle%2520Chrome'\
#   '%26needsadmin%3Dfalse%26ap%3Dx64-stable-statsdef_0%26brand%3DGCEA/dl/chrome/install/googlechromestandaloneenterprise64.msi'
#   rights :full_control, 'Everyone'
#   action :create
# end

# windows_package 'chrome' do
#   action :install
#   source 'C:\Users\azure\AppData\Local\Temp\kitchen\cache\package\googlechromestandaloneenterprise64.msi'
# end

# Configure Google Chrome preferences from the 'master_preferences.json' template file
chrome 'custom_preferences' do
  action :master_preferences
end

# Set Google Chrome as the default browser via the Windows registry
if platform?('windows')
  registry_key 'HKEY_LOCAL_MACHINE\Software\Policies\Google\Chrome' do
    values [{
      name: 'DefaultBrowserSettingEnabled',
      type: :dword,
      data: 1
    }]
    recursive true
    action :create
  end
else
  log('Recipe ie::esc is only available for Windows platforms!') { level :warn }
end

# Install the Chocolatey package manager for Windows to facilitate installation of other software
include_recipe 'chocolatey::default'

# Install git
include_recipe 'git::windows'

# Create directory for demo files
directory 'C:\Contrast' do
  rights :full_control, 'Everyone'
  inherits false
  action :create
end

# Add Linux container support to Docker Enterprise on Windows
if platform?('windows')
  cookbook_file 'C:\Contrast\release.zip' do
    source 'release.zip'
    rights :full_control, 'Everyone'
    action :create
  end

  powershell_script 'Extract the Linux kit container support ZIP file, configure, and restart docker service' do
    code <<-EOH
    Expand-Archive release.zip -DestinationPath "$Env:ProgramFiles\\Linux Containers\\."
    '{"experimental":true}' | Out-File "$Env:ProgramData\\docker\\config\\daemon.json" -encoding ASCII
    [Environment]::SetEnvironmentVariable("LCOW_SUPPORTED", "1", "Machine")
    Restart-Service docker
    EOH
    cwd 'C:\Contrast'
    action :run
  end
else
  log('Recipe ie::esc is only available for Windows platforms!') { level :warn }
end

# Install docker-compose
if platform?('windows')
  cookbook_file 'C:\Program Files\Docker\docker-compose.exe' do
    source 'docker-compose.exe'
    rights :full_control, 'Everyone'
    action :create
  end
else
  log('Recipe ie::esc is only available for Windows platforms!') { level :warn }
end

# Disable Internet Explorer Enhanced Security Configuration since it interferes with signing into Visual Studio and other tools
if platform?('windows')
  registry_key 'HKLM\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}' do
    values [{ name: 'IsInstalled', type: :dword, data: 0 }]
  end

  registry_key 'HKLM\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}' do
    values [{ name: 'IsInstalled', type: :dword, data: 0 }]
  end

  registry_key 'HKLM\SOFTWARE\Microsoft\Active Setup\Installed Components\ChefIE_ESCZoneMap_IEHarden' do
    values [
      { name: 'Version', type: :string, data: Time.now.to_i },
      { name: 'StubPath', type: :string, data: 'reg add "HKCU\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\' \
        "Internet Settings\\ZoneMap\" /v IEHarden /d 0 /t REG_DWORD /f" }
    ]
  end
else
  log('Recipe ie::esc is only available for Windows platforms!') { level :warn }
end

# Install Microsoft Visual C++ 2013 run-time (required by MySQL)
#include_recipe 'vcruntime::vc12'

# Install Node.js and NPM
chocolatey_package 'nodejs' do
  action :install
end

# Install Java 8 from https://chocolatey.org/packages/jdk8
chocolatey_package 'jdk8' do
  action :install
end

# Install Maven 3.6.3 from https://chocolatey.org/packages/maven
chocolatey_package 'maven' do
  action :install
end

# Add Maven bin directory to Windows PATH
windows_path 'C:\ProgramData\chocolatey\lib\maven\apache-maven-3.6.3\bin' do
  action :add
end

# From https://chocolatey.org/packages/eclipse
chocolatey_package 'eclipse' do
  action :install
end


# Windows will need to be rebooted after Docker and MySQL is installed
reboot 'Restart Computer' do
  action :nothing
  ignore_failure true
end
