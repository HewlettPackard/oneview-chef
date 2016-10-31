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

# Creates on server profile with the desired Enclosure group and Server hardware type
oneview_server_profile 'ServerProfile1' do
  client my_client
  enclosure_group 'EnclosureGroup1'
  server_hardware_type 'DL360 Gen8 1'
end

# Creates on server profile with the desired Enclosure group and Server hardware type and some connections
oneview_server_profile 'ServerProfile2' do
  client my_client
  enclosure_group 'EnclosureGroup2'
  server_hardware_type 'DL360 Gen9 1'
  data(
    'macType' => 'Virtual',
    'wwnType' => 'Virtual'
  )
  ethernet_network_connections(
    'EthernetNetwork1' => {
      'name' => 'Connection1'
    }
  )
  fc_network_connections(
    'FCNetwork1' => {
      'name' => 'Connection2',
      'functionType' => 'FibreChannel',
      'portId' => 'Auto'
    }
  )
  action :create_if_missing
end

# Deletes server profile 'ServerProfile2'
oneview_server_profile 'ServerProfile2' do
  client my_client
  action :delete
end
