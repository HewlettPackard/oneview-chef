#
# Cookbook Name:: oneview_test_api500_synergy
# Recipe:: volume_template_create_if_missing
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

oneview_volume_template 'VolumeTemplate1' do
  client node['oneview_test']['client']
  data(
    family: 'StoreServ',
    properties: {
      provisioningType: {
        type: 'string',
        required: true,
        enum: [
          'Thin',
          'Full'
        ],
        default: 'Full'
      },
      isShareable: {
        type: 'boolean',
        default: true,
        meta: {
          locked: true
        }
      },
      size: {
        type: 'integer',
        minimum: 1024 * 1024 * 1024 # 1GB
      }
    }
  )
  storage_system '172.18.11.11'
  storage_pool 'CPG-SSD'
  action :create_if_missing
end
