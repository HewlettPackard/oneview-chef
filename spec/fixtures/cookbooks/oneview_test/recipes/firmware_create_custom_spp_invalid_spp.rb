#
# Cookbook Name:: oneview_test
# Recipe:: firmware_create_custom_spp_invalid_spp
#
# (c) Copyright 2016 Hewlett Packard Enterprise Development LP
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

oneview_firmware 'CustomSPP1' do
  client node['oneview_test']['client']
  hotfixes_names [
    'Online ROM Flash Component for Windows x64 - HPE Synergy 620/680 Gen9 Compute Module'
  ]
  action :create_custom_spp
end
