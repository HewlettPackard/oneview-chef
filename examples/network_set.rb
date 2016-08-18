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

client = {
  url: '',
  user: '',
  password: ''
}

oneview_ethernet_network 'ChefBulkEthernet' do
  client client
  data(
    'vlanIdRange' => '10-12',
    'purpose' =>  'General',
    'smartLink' => false,
    'privateNetwork' => false
  )
  action :bulk_create
end

oneview_network_set 'ChefNetworkSet_0' do
  client client
  action :create
end

oneview_network_set 'ChefNetworkSet_1' do
  client client
  native_network 'ChefBulkEthernet_10'
  ethernet_network_list ['ChefBulkEthernet_11', 'ChefBulkEthernet_12']
  action :create
end

oneview_network_set 'ChefNetworkSet_2' do
  client client
  native_network 'ChefBulkEthernet_10'
  ethernet_network_list ['ChefBulkEthernet_11']
  action :create_if_missing
end

oneview_network_set 'ChefNetworkSet_0' do
  client client
  action :delete
end

oneview_network_set 'ChefNetworkSet_1' do
  client client
  action :delete
end

oneview_network_set 'ChefNetworkSet_2' do
  client client
  action :delete
end

oneview_ethernet_network 'ChefBulkEthernet_10' do
  client client
  action :delete
end

oneview_ethernet_network 'ChefBulkEthernet_11' do
  client client
  action :delete
end

oneview_ethernet_network 'ChefBulkEthernet_12' do
  client client
  action :delete
end
