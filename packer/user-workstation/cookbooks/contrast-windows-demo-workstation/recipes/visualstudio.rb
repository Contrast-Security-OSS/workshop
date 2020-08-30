# 
# Cookbook:: contrast-windows-demo-workstation
# Recipe:: visualstudio
#
# Copyright:: 2019, The Authors, All Rights Reserved.

# Get Visual Studio 2017 Community bootstrapper
# Visual Studio 207 Community bootstrapper executable is downloaded from https://visualstudio.microsoft.com/thank-you-downloading-visual-studio/?sku=community&rel=15&utm_medium=microsoft&utm_source=docs.microsoft.com&utm_campaign=link+cta&utm_content=download+commandline+parameters+vs2017
# The executable is renamed to have a `.installer` extension
cookbook_file 'C:\Contrast\vs_community.exe' do
  source 'vs_community__1756504193.1522096730.installer'
  rights :full_control, 'Everyone'
  action :create
end

# Install Visual Studio 2017 Community Edition and Workloads for .NET, ASP.NET, and .NET Core development
execute 'Install Visual Studio 2017 Community Edition and Workloads' do
  command 'vs_community.exe --passive --add Microsoft.VisualStudio.Product.Community --add Microsoft.VisualStudio.Workload.ManagedDesktop --add Microsoft.VisualStudio.Workload.NetWeb --add Microsoft.VisualStudio.Workload.NetCoreTools --includeRecommended --wait'
  cwd 'C:\Contrast'
  returns [0, 3010]
  action :run
  notifies :create, 'remote_file[C:\Contrast\contrast-visual-studio-extension.vsix]', :immediately
end

# Download Contrast Security IDE plugin for Visual Studio
# https://marketplace.visualstudio.com/items?itemName=contrast-security.contrast-vs-ext
remote_file 'C:\Contrast\contrast-visual-studio-extension.vsix' do
  source 'https://contrast-security.gallerycdn.vsassets.io/extensions/contrast-security/contrast-vs-ext/2.1.0/1570720580791/contrast-visual-studio-extension.vsix'
  rights :full_control, 'Everyone'
  action :nothing
  only_if { ::File.directory?('C:\Program Files (x86)\Microsoft Visual Studio\2017\Community') }
  notifies :run, 'execute[Install Contrast for Visual Studio extension]', :immediately
end

# Install the 'Contrast for Visual Studio' IDE plugin
# http://www.visualstudioextensibility.com/2017/02/21/using-vsixinstaller-exe-to-install-programmatically-an-extension-to-visual-studio-2015-and-visual-studio-2017/
execute 'Install Contrast for Visual Studio extension' do
  command 'VSIXInstaller.exe /skuName:Community /skuVersion:15.0 /quiet /force "C:\Contrast\contrast-visual-studio-extension.vsix"'
  cwd 'C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\IDE'
  retries 2
  retry_delay 3
  action :nothing
end
