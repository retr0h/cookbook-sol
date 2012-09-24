#
# Cookbook Name:: sol
# Recipe:: default
#
# Copyright 2011,2012 John Dewey
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

include_recipe "reboot-handler"

# Note: /etc/securetty already has entries for ttyS* under Ubuntu.

template node['sol']['tty']['conf'] do
  source "ttyS1.conf.erb"
  owner  "root"
  group  "root"
  mode   0644
end

ruby_block "setting reboot flag" do
  block do
    node.run_state['reboot'] = true
  end

  action :nothing
end

execute "update-grub" do
  action :nothing

  notifies :create, resources(:ruby_block => "setting reboot flag")
end

template node['sol']['grub']['conf'] do
  source "grub.erb"
  owner  "root"
  group  "root"
  mode   0644

  notifies :run, resources(:execute => "update-grub")
end
