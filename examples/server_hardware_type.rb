# (c) Copyright 2021 Hewlett Packard Enterprise Development LP
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
  password: ENV['ONEVIEWSDK_PASSWORD'],
  api_version: 2600,
  api_variant: 'Synergy'
}

sht_name = 'SY 480 Gen9 1'

# Example: Update server hardware type properties
oneview_server_hardware_type sht_name do
  client my_client
  data(
    description: 'Server hardware type description'
  )
end

# Delete operation will work only in C7000
# Example: Remove server hardware type
oneview_server_hardware_type sht_name do
  client my_client
  action :remove
  only_if { client[:api_variant] == 'C7000' }
end
