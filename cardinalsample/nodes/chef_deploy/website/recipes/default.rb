#
# Cookbook:: website
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.
apt_update 'Update' do
  frequency 86_400
  action :periodic
end
package node['website']['package']
cookbook_file "#{node['website']['docroot']}/fuse.html" do
  source 'fuse.html'
  action :create
end
service node['website']['service'] do
  supports status: true, restart: true, reload: true
  action %i(enable start)
end