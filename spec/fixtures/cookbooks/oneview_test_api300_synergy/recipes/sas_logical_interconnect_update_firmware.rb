#
# Cookbook Name:: oneview_test_api300_synergy
# Recipe:: sas_logical_interconnect_update_firmware
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

oneview_sas_logical_interconnect 'SASLogicalInterconnect-update_firmware' do
  client node['oneview_test']['client']
  data(
    'uri' => 'mock/uri'
  )
  firmware 'Unit SPP'
  firmware_data(
    ethernetActivationDelay: 10,
    ethernetActivationType: 'OddEven',
    force: true
  )
  action :update_firmware
end
