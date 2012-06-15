#
# Author:: KC Braunschweig (<kcbraunschweig@gmail.com>)
# Cookbook Name:: cycleserver
# Recipe:: grill
#
# Copyright 2012, KC Braunschweig
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Sanity check install source
tarball_url = node["cycle_server"]["grill"]["url"]
install_file = File.basename(tarball_url)
install_name = File.basename(tarball_url, '.tar.gz')

if tarball_url =~ /example.com/
  Chef::Application.fatal!("You must change the download url to your private repository.")
end

# Sanity check memory settings
mem_req = ( node["cycle_server"]["grill"]["webServerMaxHeapSizeMB"].to_i +
    node["cycle_server"]["grill"]["databaseMaxHeapSizeMB"].to_i +
    node["cycle_server"]["grill"]["brokerMaxHeapSizeMB"].to_i )
if mem_req > ( node[:memory][:total].to_i / 1024 * 0.90 )
  Chef::Application.fatal!("Component heap size attributes require more than 90% of total system memory. Cowardly refusing to continue")
end

# You can disable inclusion of the java recipe if you have your own way of providing it
if node["cycle_server"]["grill"]["include_java"]
  unless node["java"]["install_flavor"] =~ /oracle/
    Chef::Application.fatal!("Only Oracle Java is supported. You must change your java install_flavor")
  end

  include_recipe "java"
end

# Make the recipe more concise
grill_user = node["cycle_server"]["grill"]["user"]
grill_group = node["cycle_server"]["grill"]["group"]

# You can disable management of the Grill user/group if you have your own way of providing it
if node["cycle_server"]["grill"]["manage_user"]
  group grill_group do
    action [:create, :manage]
  end

  user grill_user do
    comment "Cycleserver Grill user"
    gid grill_group
    home "/home/#{grill_user}"
    action [:create, :manage]
    supports :manage_home => true
  end
end

remote_file "#{Chef::Config[:file_cache_path]}/#{install_file}" do
  source tarball_url
  mode "0644"
  owner grill_user
  group grill_group
  checksum node["cycle_server"]["grill"]["checksum"]
end

# Check if we've installed this version before
unless File.directory?("/opt/#{install_name}")

  # Grill is packaged as "cycleserver" directory so extract it temporarily
  execute "extract_grill" do
    command "tar zxf #{Chef::Config[:file_cache_path]}/#{install_file} -C #{Chef::Config[:file_cache_path]}/"
  end

  execute "move_grill" do
    command "mv #{Chef::Config[:file_cache_path]}/cycle_server /opt/#{install_name}"
  end

  execute "chown_grill" do
    command "chown -R #{grill_user}:#{grill_group} /opt/#{install_name}"
  end

  link "/opt/cycle_server" do
    to "/opt/#{install_name}"
  end

end #unless installed

template "/etc/init.d/cycle_server" do
  source "cycle_server.init.erb"
  owner "root"
  group "root"
  mode "0755"
  variables(
      :grill_user => grill_user
  )
end

template "/etc/logrotate.d/cycle_server" do
  source "cycle_server.logrotate.erb"
  owner "root"
  group "root"
  mode "0644"
end

template "/opt/cycle_server/config/cycle_server.properties" do
  source "cycle_server.properties.erb"
  owner grill_user
  group grill_group
  mode "0644"
  notifies :restart, "service[cycle_server]"
end

service "cycle_server" do
  supports :status => false, :restart => true
  status_command "ps -ef | grep [c]ycle_server"
  action [ :start, :enable ]
end