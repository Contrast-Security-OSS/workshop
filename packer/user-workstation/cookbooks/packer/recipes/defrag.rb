remote_file ::File.join(Chef::Config[:file_cache_path], 'ultradefrag.zip') do
  source 'https://downloads.sourceforge.net/project/ultradefrag/stable-release/7.1.2/ultradefrag-portable-7.1.2.bin.amd64.zip'
  action :create
end

windows_zipfile 'Decompress ultradefrag' do
  source ::File.join(Chef::Config[:file_cache_path], 'ultradefrag.zip')
  path ::File.join(Chef::Config[:file_cache_path])
  action :unzip
end

execute 'Rename ultradefrag' do
  command "move #{::File.join(Chef::Config[:file_cache_path])}\\ultradefrag-* #{::File.join(Chef::Config[:file_cache_path], 'ultradefrag')}"
  not_if { ::File.exist?(::File.join(Chef::Config[:file_cache_path], 'ultradefrag')) }
end

execute 'Change UltraDefrag time limit' do
  command 'set UD_TIME_LIMIT=6h'
end

execute 'Run ultradefrag' do
  command "#{::File.join(Chef::Config[:file_cache_path], 'ultradefrag', 'udefrag.exe')} --optimize --repeat %SystemDrive%"
  timeout 21600
  action :run
end
