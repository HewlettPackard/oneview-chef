#
# Cookbook Name:: oneview_test_api300_synergy
# Recipe:: switch_remove_from_scopes
#
# (c) Copyright 2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.
#

oneview_switch 'Switch1' do
  client node['oneview_test']['client']
  api_version 300
  api_variant 'C7000'
  scopes ['Scope1', 'Scope2']
  action :remove_from_scopes
end
