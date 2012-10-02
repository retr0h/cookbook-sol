#
# Cookbook Name:: cookbook-raid
# Recipe:: megaraid
#
# Copyright 2012, John Dewey
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
include_recipe "megaraidcli"
include_recipe "parted"
include_recipe "rsync"

def enclosure_for disks
  disks.inject([]) { |result, disk|
    result << "#{node['raid']['lsi']['megaraid']['enclosure_id']}:#{disk}"
    result
  }
end

array0 = enclosure_for node['raid']['lsi']['megaraid']['disks'][0]
array1 = enclosure_for node['raid']['lsi']['megaraid']['disks'][1]
spares = enclosure_for node['raid']['lsi']['megaraid']['spares']

ruby_block "setting node attributes" do
  block do
    node.run_state['reboot'] = true
    node['raid']['configured'] = true
  end

  action :nothing
end

execute "clearing adapter" do
  command "#{node['megaraidcli']['wrapper']} -cfglddel -lall -a#{node['raid']['lsi']['megaraid']['adapter']}; sleep 30"
end

execute "creating raid 1+0" do
  command "#{node['megaraidcli']['wrapper']} -CfgSpanAdd -r10 -Array0[#{array0}] -Array1[#{array1}] #{node['raid']['lsi']['megaraid']['options']} -a#{node['raid']['lsi']['megaraid']['adapter']}"
end

execute "adds spares" do
  command "#{node['megaraidcli']['wrapper']} -pdhsp -set -physdrv [#{spares}] -a#{node['raid']['lsi']['megaraid']['adapter']}"

  notifies :create, resources(:ruby_block => "setting node attributes")
end

# Prepare the array for a /var pivot.  If we end up adding configuration of another raid device
# to this cookbook, will probably move the following into a different recipe.

execute "parted #{node['raid']['raw_device']} --script -- mklabel gpt"
execute "parted #{node['raid']['raw_device']} --script -- mkpart primary #{node['raid']['fs']} 1 -1"
execute "mkfs.#{node['raid']['fs']} #{node['raid']['block_device']}"
execute "mkdir -p /var2"
execute "mount #{node['raid']['block_device']} /var2"
execute "rsync -a /var/* /var2/"
