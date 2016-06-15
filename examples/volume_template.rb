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

# NOTE: This recipe requires one Storage System with IP '172.18.11.11'
# and one Storage Pool named 'CPG-SSD-AO' associated to this Storage System

my_client = {
  url: 'https://XXX.XXX.XXX.XXX/',
  user: 'USR',
  password: 'PWD',
  ssl_enabled: false
}

volume_template_data_1 = {
  description: 'CHEF created Volume Template',
  provisioning: {
    provisionType: 'Full',
    shareable: true,
    capacity: 1024 * 1024 * 1024 # 1GB
  }
}

oneview_volume_template 'CHEF_VOL_TEMP_01' do
  client my_client
  data volume_template_data_1
  storage_system_ip '172.18.11.11'
  storage_pool 'CPG-SSD-AO'
  action :create
end

oneview_volume_template 'CHEF_VOL_TEMP_01' do
  client my_client
  action :delete
end
