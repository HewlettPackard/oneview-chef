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
  password: ''
}

# Create a few networks for the next examples
(0..2).each do |i|
  oneview_ethernet_network "Chef-Eth-Net-#{i}" do
    client my_client
    data(
      vlanId: "5#{i}".to_i,
      purpose: 'General',
      smartLink: false,
      privateNetwork: false
    )
  end
end

# Example: Create an empty network set
oneview_network_set 'ChefNetworkSet_0' do
  client my_client
  action :create
end

# Example: Create a network set with a few networks
oneview_network_set 'ChefNetworkSet_1' do
  client my_client
  native_network 'Chef-Eth-Net-0'
  ethernet_network_list ['Chef-Eth-Net-1', 'Chef-Eth-Net-2']
  action :create
end

# Example: Create a network set only if it doesn't exist (no updates)
oneview_network_set 'ChefNetworkSet_2' do
  client my_client
  native_network 'Chef-Eth-Net-2'
  ethernet_network_list ['Chef-Eth-Net-1']
  action :create_if_missing
end

# Examples: Delete the network sets
(0..2).each do |i|
  oneview_network_set "Delete ChefNetworkSet_#{i}" do
    data(name: "ChefNetworkSet_#{i}")
    client my_client
    action :delete
  end
end

# Clean up the ethernet networks
(0..2).each do |i|
  oneview_ethernet_network "Delete Chef-Eth-Net-#{i}" do
    data(name: "Chef-Eth-Net-#{i}")
    client my_client
    action :delete
  end
end
