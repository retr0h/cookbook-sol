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

module SolHelper
  def manufacturer
    return unless node['dmi']['system']['manufacturer']

    node['dmi']['system']['manufacturer'].
      strip.                   # remove leading/trailing space
      gsub(/\s+/, "-").        # replace spaces with hyphens
      gsub(/[^a-zA-Z-]+/, ""). # strip non-alphanumeric/non-hyphens
      downcase
  end

  def value_for type, value
    vendor_specific = node['sol'][manufacturer] if node['sol'][manufacturer]

    ((vendor_specific &&
      vendor_specific[type] &&
      vendor_specific[type][value]) || node['sol'][type][value])
  end
end

class Chef::Recipe
  include SolHelper
end

class Chef::Resource::Template
  include SolHelper
end

getty = "#{value_for("tty", "name")}.conf"
template ::File.join(node['sol']['tty']['dir'], getty) do
  source "ttyS1.conf.erb"
  owner  "root"
  group  "root"
  mode   0644

  variables(
    :name  => value_for("tty", "name"),
    :speed => value_for("serial", "speed")
  )
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

  variables(
    :tty_name                   => value_for("tty", "name"),
    :serial_speed               => value_for("serial", "speed"),
    :serial_unit                => value_for("serial", "unit"),
    :serial_word                => value_for("serial", "word"),
    :serial_parity              => value_for("serial", "parity"),
    :serial_stop                => value_for("serial", "stop"),
    :serial_bios_speed          => value_for("serial", "bios_speed"),
    :grub_default               => value_for("grub", "default"),
    :grub_hidden_timeout        => value_for("grub", "hidden_timeout"),
    :grub_hidden_timeout_quiet  => value_for("grub", "hidden_timeout_quiet"),
    :grub_timeout               => value_for("grub", "timeout"),
    :grub_cmdline_linux_default => value_for("grub", "cmdline_linux_default")
  )

  notifies :run, resources(:execute => "update-grub")
end
