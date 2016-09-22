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

oneview_server_hardware '172.18.6.4' do
  client my_client
  data(
    hostname: '172.18.6.4',
    username: 'user',
    password: 'password',
    licensingIntent: 'OneViewStandard',
    configurationState: "Monitored"
  )
end

oneview_server_hardware '172.18.6.4' do
  client my_client
  power_state 'on'
  action :set_power_state
end

oneview_server_hardware '172.18.6.4' do
  client my_client
  action :refresh
end

oneview_server_hardware '172.18.6.4' do
  client my_client
  action :update_ilo_firmware
end

oneview_server_hardware '172.18.6.4' do
  client my_client
  action :remove
end
