# (c) Copyright 2020 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

# NOTE: This recipe requires:
# Managed SAN: VSAN10 (must have state "Managed")
# Scopes: Scope1, Scope2

# NOTE 2: The api_version client should be 300 or greater if you run the examples using Scopes

OneviewCookbook::Helper.load_sdk(self)

my_client = {
  url: ENV['ONEVIEWSDK_URL'],
  user: ENV['ONEVIEWSDK_USER'],
  password: ENV['ONEVIEWSDK_PASSWORD'],
  api_version: 2200
}

oneview_fcoe_network 'FCoE1' do
  data(
    vlanId: 10,
    bandwidth: {
      typicalBandwidth: 2000,
      maximumBandwidth: 9000
    }
  )
  client my_client
  action :create
end

# Example: Bulk deletes fcoe networks.
oneview_fcoe_network 'None' do
  client my_client
  test1 = OneviewCookbook::Helper.load_resource(my_client, type: 'FCoENetwork', id: 'FcoeTest1')
  data(
    networkUris: [ test1['uri'] ]
  )
  action :delete_bulk
end

# Reset the connection template for 'FCoE1'
oneview_fcoe_network 'FCoE1' do
  client my_client
  action :reset_connection_template
end

#Deletes 'FCoE1' network
oneview_fcoe_network 'FCoE1' do
  client my_client
  action :delete
end
