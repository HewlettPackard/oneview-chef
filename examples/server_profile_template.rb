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

# NOTES:
# This example requires the following resources to be available in the appliance:
#  - Server Profile: 'ServerProfile1'
#  - Server Hardware Type: 'BL660c Gen9 1'
#  - Enclosure Group: 'EnclosureGroup1'

my_client = {
  url: ENV['ONEVIEWSDK_URL'],
  user: ENV['ONEVIEWSDK_USER'],
  password: ENV['ONEVIEWSDK_PASSWORD']
}

enclosure_group = 'EnclosureGroup1'
server_hardware_type = 'BL660c Gen9 1'
sp_name = 'ServerProfile1'

# Creates on server profile template with the desired Enclosure group and Server hardware type
oneview_server_profile_template 'ServerProfileTemplate1' do
  client my_client
  enclosure_group enclosure_group
  server_hardware_type server_hardware_type
end

# Creates on server profile template with the desired Enclosure group and Server hardware type
oneview_server_profile_template 'ServerProfileTemplate1' do
  client my_client
  enclosure_group enclosure_group
  server_hardware_type server_hardware_type
  action :create_if_missing
end

# Creates a server profile template using the server profile 'ServerProfile1' as a templates
# Note: Only to api 500 or greater, comments this recipe if you do not running using api500
oneview_server_profile_template 'ServerProfileTemplate2' do
  client my_client
  api_version 500
  server_profile_name sp_name
end

# Deletes server profile 'ServerProfileTemplate1'
oneview_server_profile_template 'ServerProfileTemplate1' do
  client my_client
  action :delete
end

# Deletes server profile 'ServerProfileTemplate2'
oneview_server_profile_template 'ServerProfileTemplate2' do
  client my_client
  action :delete
end
