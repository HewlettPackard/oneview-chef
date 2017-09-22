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
  url: ENV['ONEVIEWSDK_URL'],
  user: ENV['ONEVIEWSDK_USER'],
  password: ENV['ONEVIEWSDK_PASSWORD']
}

# Adds a power delivery device or update if it already exists
oneview_power_device 'PowerDevice1' do
  client my_client
  data(
    ratedCapacity: 40
  )
end

# Add if power delivery device is not present, does not update
oneview_power_device 'PowerDevice1' do
  client my_client
  data(
    ratedCapacity: 40
  )
  action :add_if_missing
end

# Discovers an iPDU
oneview_power_device '127.0.0.1' do
  client my_client
  username 'username'
  password 'password'
  auto_import_certificate false # Optional property, default is true
  action :discover
end

# Refreshes an iPDU
oneview_power_device '127.0.0.1' do
  client my_client
  action :refresh
end

# Sets UID state of an iPDU (use a power device that accept change the uid state)
oneview_power_device '127.0.0.1' do
  client my_client
  uid_state 'off'
  action :set_uid_state
end

# Sets the power state of an iPDU (use a power device that accept change the power state)
oneview_power_device '127.0.0.1' do
  client my_client
  power_state 'off'
  action :set_power_state
end

# Removes a power delivery device
oneview_power_device 'PowerDevice1' do
  client my_client
  action :remove
end

# Removes an iPDU by hostname
oneview_power_device '127.0.0.1' do
  client my_client
  action :remove
end
