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

# NOTES:
# This example requires the following resources to be available in the appliance:
#  - FC Network: 'FCNetwork1'
#  - Server Hardware Type: 'BL660c Gen9 1'
#  - Storage System: 'ThreePAR-1'
#  - Storage Pool: 'cpg-growth-limit-1TiB' (managed)
#  - Enclosure Group: 'EnclosureGroup1'
#  - Volume: 'Volume1'
# To create volume attachments:
#  - The Storage System must have at least one connection using 'FCNetwork1' and this same network connection must have an uplinkSet connected on the Interconnect,
#   and the Server Hardware related to that network connection is the Server Hardware used in this example.

my_client = {
  url: ENV['ONEVIEWSDK_URL'],
  user: ENV['ONEVIEWSDK_USER'],
  password: ENV['ONEVIEWSDK_PASSWORD']
}

enclosure_group_name = 'EnclosureGroup1'
server_hardware_type_name = 'BL660c Gen9 1'
fc_network_connection_data = {
  FCNetwork1: {
    id: 1,
    name: 'Connection1',
    functionType: 'FibreChannel',
    portId: 'Auto'
  }
}

volume_attachments_list = [
  {
    volume: 'Volume1',
    attachment_data: {
      id: 1,
      lunType: 'Auto',
      storagePaths: [
        {
          isEnabled: true,
          storageTargetType: 'Auto',
          connectionId: 1
        }
      ]
    }
  },
  {
    volume_data: {
      name: 'Volume2',
      description: 'volume for api200 or api300',
      provisioningParameters: {
        provisionType: 'Full',
        requestedCapacity: 1024 * 1024 * 1024,
        shareable: false
      }
    },
    storage_system: 'ThreePAR-1',
    storage_pool: 'cpg-growth-limit-1TiB',
    host_os_type: 'Windows 2012 / WS2012 R2',
    attachment_data: {
      id: 2,
      lunType: 'Auto',
      storagePaths: [
        {
          isEnabled: true,
          storageTargetType: 'Auto',
          connectionId: 1
        }
      ]
    }
  }
]

# Creates a Server Profile Template with volume attachments
oneview_server_profile_template 'ServerProfileTemplate1' do
  client my_client
  enclosure_group enclosure_group_name
  server_hardware_type server_hardware_type_name
  fc_network_connections fc_network_connection_data
  volume_attachments volume_attachments_list
end


# Creates a Server Profile with volume attachments
oneview_server_profile 'ServerProfile1' do
  client my_client
  enclosure_group enclosure_group_name
  server_hardware_type server_hardware_type_name
  fc_network_connections fc_network_connection_data
  volume_attachments volume_attachments_list
end

# Deletes server profile created
oneview_server_profile_template 'ServerProfileTemplate1' do
  client my_client
  action :delete
end

# Deletes server profile created
oneview_server_profile 'ServerProfile1' do
  client my_client
  action :delete
end
