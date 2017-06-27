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

my_client = {
  url: ENV['ONEVIEWSDK_URL'],
  user: ENV['ONEVIEWSDK_USER'],
  password: ENV['ONEVIEWSDK_PASSWORD']
}

ids = ['A2:32:C3:D0:00:00', 'A2:32:C3:D0:00:01']

# Example: Disabling a ID Pool
oneview_id_pool 'VMAC Pool' do
  client my_client
  pool_type 'vmac'
  enabled false
  action :update
end

# Example: Enabling a ID Pool
oneview_id_pool 'VMAC Pool' do
  client my_client
  pool_type 'vmac'
  enabled true
  action :update
end

# Example: Allocating a list of the IDs
oneview_id_pool 'VMAC Pool' do
  client my_client
  pool_type 'vmac'
  id_list ids
end

# Example: Allocating a certain quantity of IDs
oneview_id_pool 'VMAC Pool' do
  client my_client
  pool_type 'vmac'
  count 2
  action :allocate_count
end

# Example: Removing a list of the IDs
oneview_id_pool 'VMAC Pool' do
  client my_client
  pool_type 'vmac'
  id_list ids
  action :collect_ids
end
