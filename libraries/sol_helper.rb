# encoding: UTF-8
#
# Cookbook Name:: sol
# library:: sol_helper
#
# Copyright 2014, John Dewey
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

module SolHelper # rubocop:disable Documentation
  def manufacturer
    return unless node['dmi']['system']['manufacturer']

    node['dmi']['system']['manufacturer']
      .strip                   # remove leading/trailing space
      .gsub(/\s+/, '-')        # replace spaces with hyphens
      .gsub(/[^a-zA-Z-]+/, '') # strip non-alphanumeric/non-hyphens
      .downcase
  end

  def vendor_specific_value(type, value)
    vendor_specific = node['sol'][manufacturer] if node['sol'][manufacturer]
    vendor_specific && vendor_specific[type] && vendor_specific[type][value]
  end

  def value_for(type, value)
    vendor_specific_value(type, value) || node['sol'][type][value]
  end
end
