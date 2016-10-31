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

# Creates on server profile template with the desired Enclosure group and Server hardware type
oneview_server_profile_template 'ServerProfileTemplate1' do
  client my_client
  enclosure_group 'EnclosureGroup1'
  server_hardware_type 'DL360 Gen8 1'
end

# Creates on server profile template with the desired Enclosure group and Server hardware type
oneview_server_profile_template 'ServerProfileTemplate1' do
  client my_client
  enclosure_group 'EnclosureGroup1'
  server_hardware_type 'DL360 Gen8 1'
  action :create_if_missing
end

# Deletes server profile 'ServerProfile2'
oneview_server_profile 'ServerProfileTemplate1' do
  client my_client
  action :delete
end

# Creates a server profile from 'ServerProfileTemplate1'
oneview_server_profile 'ServerProfileTemplate1' do
  client my_client
  profile_name 'ServerProfile1'
  action :new_profile
end
