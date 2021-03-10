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
  variant: 'Synergy',
  api_version: 2600
}

# Example: Create a logical enclosure if it's missing
# Available only for Synergy
oneview_logical_enclosure 'LE' do
  client my_client
  data(
    firmwareBaselineUri: nil
  )
  enclosures ['0000A66103', '0000A66102', '0000A66101'] # List of enclosure names, serial numbers or OA IPs
  enclosure_group 'EG'
  action :create_if_missing # This is the default action, so you don't need to specify it
  only_if { client[:variant] == 'Synergy' }
end

# Example: Make a logical enclosure consistent with the enclosure group
# Note that this resource will do this action every time; it's meant to be notified to run,
# not as a standalone resource like this.
oneview_logical_enclosure 'LE' do
  client my_client
  action :update_from_group
end

# Example: Reapply the appliance's configuration on enclosures for a logical enclosure
# Note that this resource will do this action every time; it's meant to be notified to run,
# not as a standalone resource like this.
oneview_logical_enclosure 'LE' do
  client my_client
  action :reconfigure
end

# Example: Set the configuration script of the logical enclosure and on all enclosures in the logical enclosure
# Available only for C7000
oneview_logical_enclosure 'LE' do
  client my_client
  script '# My script commands here'
  action :set_script
  only_if { client[:variant] == 'C7000' }
end

# Example: Creates a support dump for the logical enclosure
oneview_logical_enclosure 'LE' do
  client my_client
  dump_options(
    errorCode: 'MyDump'
  )
  action :create_support_dump
end

# Example: Delete a logical enclosure, logical interconnects and put all attached enclosures and their components to the Monitored state
# Available only for Synergy
oneview_logical_enclosure 'LE' do
  client my_client
  action :delete
  only_if { client[:variant] == 'Synergy' }
end
