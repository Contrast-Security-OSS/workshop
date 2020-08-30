name 'contrast-windows-demo-workstation'
maintainer 'The Authors'
maintainer_email 'you@example.com'
license 'All Rights Reserved'
description 'Installs/Configures contrast-windows-demo-workstation'
long_description 'Installs/Configures contrast-windows-demo-workstation'
version '0.1.4'
chef_version '>= 12.14' if respond_to?(:chef_version)
depends 'windows'
depends 'seven_zip', '~> 3.1.1'
depends 'chrome', '~> 4.0.2'
depends 'chocolatey', '~> 2.0.1'
depends 'iis', '~> 7.2.0'
depends 'git', '~> 9.0.1'
depends 'ms_dotnet', '~> 4.2.1'
depends 'mysql-windows', '~> 5.5.43'