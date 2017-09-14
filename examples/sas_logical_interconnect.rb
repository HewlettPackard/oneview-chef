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

# No action
oneview_sas_logical_interconnect 'Encl1-SASLogicalInterconnectGroup1' do
  api_version 300
  api_variant 'Synergy'
  client my_client
end

# Initiates a Drive enclosure update after they are physically replaced.
# It can be done in three different ways.
# First one is specifying the Drive enclosure names
oneview_sas_logical_interconnect 'Encl1-SASLogicalInterconnectGroup1' do
  api_version 300
  api_variant 'Synergy'
  client my_client
  old_drive_enclosure 'DriveEnclosure1'
  new_drive_enclosure 'DriveEnclosure2'
  action :replace_drive_enclosure
end

# Second one is specifying the Drive enclosures serial numbers
oneview_sas_logical_interconnect 'Encl1-SASLogicalInterconnectGroup1' do
  api_version 300
  api_variant 'Synergy'
  client my_client
  old_drive_enclosure 'SN10011E'
  new_drive_enclosure 'SN10136F'
  action :replace_drive_enclosure
end

# Last one is specifying the Drive enclosures serial numbers directly into data property
oneview_sas_logical_interconnect 'Encl1-SASLogicalInterconnectGroup1' do
  api_version 300
  api_variant 'Synergy'
  client my_client
  data(
    oldSerialNumber: 'SN10011E',
    newSerialNumber: 'SN10136F'
  )
  action :replace_drive_enclosure
end

# Stage one firmware bundle in the Logical Interconnect with sme flahsing options
oneview_sas_logical_interconnect 'Encl1-SASLogicalInterconnectGroup1' do
  api_version 300
  api_variant 'Synergy'
  client my_client
  firmware 'ROM Flash - SPP'
  firmware_data(
    force: false
  )
  action :stage_firmware
end

# Update the staged firmware driver flahsing options
oneview_sas_logical_interconnect 'Encl1-SASLogicalInterconnectGroup1' do
  api_version 300
  api_variant 'Synergy'
  client my_client
  firmware 'ROM Flash - SPP'
  firmware_data(
    fwActivationMode: 'Parallel',
    validationType: 'None',
    force: false
  )
  action :update_firmware
end

# Activate the staged firmware in the logical interconnect
# It starts the flashing process in each managed interconnect
oneview_sas_logical_interconnect 'Encl1-SASLogicalInterconnectGroup1' do
  api_version 300
  api_variant 'Synergy'
  client my_client
  firmware 'ROM Flash - SPP'
  firmware_data(
    force: false
  )
  action :activate_firmware
end

# Start to reapply the configuration in each managed interconnect
oneview_sas_logical_interconnect 'Encl1-SASLogicalInterconnectGroup1' do
  api_version 300
  api_variant 'Synergy'
  client my_client
  action :reapply_configuration
end

# Compliance update
# Update the logical interconnect according to its associated logical interconnect group
oneview_sas_logical_interconnect 'Encl1-SASLogicalInterconnectGroup1' do
  api_version 300
  api_variant 'Synergy'
  client my_client
  action :update_from_group
end
