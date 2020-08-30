#
# Cookbook:: contrast-windows-demo-workstation
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

# Install utilities and applications and apply a base configuration to the Windows workstation
include_recipe 'contrast-windows-demo-workstation::base'

# Install and configure Visual Studio for Contrast demo purposes
include_recipe 'contrast-windows-demo-workstation::visualstudio'

## Install and configure IIS for Contrast demo purposes
#include_recipe 'contrast-windows-demo-workstation::iis'

# Install MySQL Server
include_recipe 'contrast-windows-demo-workstation::mysql'

# Install Microsoft Teams
include_recipe 'contrast-windows-demo-workstation::msteams'

# Install Contrast demo bits
include_recipe 'contrast-windows-demo-workstation::contrastdemo'

# # Install Docker Engine
# include_recipe 'contrast-windows-demo-workstation::docker'