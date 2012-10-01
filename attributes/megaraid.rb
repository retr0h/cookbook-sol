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

# Tuned for a 12 disk Quanta S99k.

default['raid']['lsi']['megaraid']['adapter'] = 0
default['raid']['lsi']['megaraid']['enclosure_id'] = 245
default['raid']['lsi']['megaraid']['disks'] = [[0,1,2,3], [4,5,6,7]]
default['raid']['lsi']['megaraid']['spares'] = [8,9,10,11]
default['raid']['lsi']['megaraid']['options'] = "WB NORA -strpsz64"

default['raid']['raw_device'] = "/dev/sdb"
default['raid']['block_device'] = "/dev/sdb1"
default['raid']['mount'] = "/var"
default['raid']['fs'] = "ext4"
