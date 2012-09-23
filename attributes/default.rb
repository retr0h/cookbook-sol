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

default['sol']['tty']['name'] = "ttyS1"
default['sol']['tty']['conf'] = ::File.join ::File::SEPARATOR, "etc", "init", "#{node['sol']['tty']['name']}.conf"

default['sol']['grub']['conf'] = ::File.join ::File::SEPARATOR, "etc", "default", "grub"
default['sol']['grub']['default'] = "0"
default['sol']['grub']['hidden_timeout'] = "0"
default['sol']['grub']['hidden_timeout_quiet'] = "true"
default['sol']['grub']['timeout'] = "10"
default['sol']['grub']['cmdline_linux_default'] = "quiet"
default['sol']['grub']['bootif'] = "eth0"

default['sol']['serial']['bios_speed'] = "115200"
default['sol']['serial']['speed'] = "38400"
default['sol']['serial']['unit'] = "0"
default['sol']['serial']['word'] = "8"
default['sol']['serial']['parity'] = "no"
default['sol']['serial']['stop'] = "1"
