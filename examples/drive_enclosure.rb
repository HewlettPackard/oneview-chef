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

my_client = {
  url: ENV['ONEVIEWSDK_URL'],
  user: ENV['ONEVIEWSDK_USER'],
  password: ENV['ONEVIEWSDK_PASSWORD'],
  api_version: 300
}

# Default action :refresh
# Initiates a refresh process
oneview_drive_enclosure 'DriveEnclosure' do
  api_version 300
  api_variant 'Synergy'
  client my_client
  # action :refresh
end

# Sets the UID light On or Off
oneview_drive_enclosure 'DriveEnclosure' do
  client my_client
  api_variant 'Synergy'
  api_version 300
  uid_light_state 'On'
  action :set_uid_light
end

# Turns the drive enclosure On or Off
oneview_drive_enclosure 'DriveEnclosure' do
  client my_client
  api_variant 'Synergy'
  api_version 300
  power_state 'On'
  action :set_power_state
end

# Performs a patch operation
# In this case, it requests a hard reset (Same as :hard_reset action)
oneview_drive_enclosure 'DriveEnclosure' do
  client my_client
  api_variant 'Synergy'
  api_version 300
  operation 'replace'
  path '/hardResetState'
  value 'Reset'
  action :patch
end

# Resets the drive enclosure interrupting I/O (Hard reset)
oneview_drive_enclosure 'DriveEnclosure' do
  client my_client
  api_variant 'Synergy'
  api_version 300
  action :hard_reset
end
