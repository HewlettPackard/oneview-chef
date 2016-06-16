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

my_client = {
  url: '',
  user: '',
  password: '',
  ssl_enabled: false
}

volume_data_1 = {
  description: 'Created from Storage Pool + Storage System',
  provisioningParameters: {
    provisionType: 'Full',
    shareable: true,
    requestedCapacity: 1024 * 1024 * 1024, # 1GB
  }
}

oneview_volume 'CHEF_VOL_01' do
  client my_client
  data volume_data_1
  storage_system_ip '172.18.11.11'
  storage_pool 'CPG-SSD-AO'
  action :create
end

oneview_volume 'CHEF_VOL_01' do
  client my_client
  action :delete
end
