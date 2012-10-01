#
# Cookbook Name:: cookbook-raid
# Recipe:: default
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

#root@o12r1:~# /usr/bin/lspci -m | /bin/grep -i "raid bus controller.*MegaRAID"
#04:00.0 "RAID bus controller" "LSI Logic / Symbios Logic" "MegaRAID SAS 2108 [Liberator]" -r05 "LSI Logic / Symbios Logic" "MegaRAID SAS 9260-8i"

unless node['raid']['configured']
  include_recipe "raid::megaraid"
end

#if(node['raid']['controller']['vendor'] == "lsi" && node['raid']['controller']['type'] == "megaraid")
#   include_recipe "megaraid"
#end
