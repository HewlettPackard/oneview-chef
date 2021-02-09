# (c) Copyright 2016-2020 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

# NOTE 1: This example requires two Scopes named "Scope1" and "Scope2" to be present in the appliance.
# NOTE 2: The api_version client should be 300 or greater if you run the examples using Scopes

my_client = {
  url: ENV['ONEVIEWSDK_URL'],
  user: ENV['ONEVIEWSDK_USER'],
  password: ENV['ONEVIEWSDK_PASSWORD'],
  api_version: 2400,
  api_variant: 'Synergy'
}

# Server hardware name variable declaration
hardware = '0000A66101, bay 8'

# Example: Add server hardware to OneView for management
# Note that the default action is :add_if_missing, and there is no :add action available.
# This is because ServerHardware resources cannot be updated after being added.
# This is supported only in C7000 variant.
oneview_server_hardware hardware do
  client my_client
  data(
    hostname: hardware,
    username: 'user',
    password: 'password',
    licensingIntent: 'OneViewStandard',
    configurationState: 'Monitored'
  )
  only_if { client[:api_variant] == 'C7000' }
end

# This is supported only in C7000 variant.
oneview_server_hardware hardware do
  client my_client
  data(
    hostname: hardware,
    username: 'user',
    password: 'password',
    licensingIntent: 'OneViewStandard',
    configurationState: 'Monitored',
    mpHostsAndRanges: ["hostname.domain", "172.18.6.5-172.18.6.24"]
  )
  action :add_multiple_servers
  only_if { client[:api_variant] == 'C7000' }
end

# Example: Make sure the server is powered on
# Note: The data hash is not required or used with this action or any of the following.
oneview_server_hardware hardware do
  client my_client
  power_state 'off'
  action :set_power_state
end

# Example: Refresh the server hardware to fix configuration issues
oneview_server_hardware hardware do
  client my_client
  action :refresh
end

# Example: Refresh the server hardware to fix configuration issues, and pass in refresh_options.
# See the API docs for other options (these will get passed into the request body)
oneview_server_hardware hardware do
  client my_client
  refresh_options(

    refreshActions: [:ClearSyslog, :PowerOff]
  )
  action :refresh
end

# Example: Update the iLO firmware on a physical server to a minimum ILO firmware
# version required by OneView to manage the server
oneview_server_hardware hardware do
  client my_client
  action :update_ilo_firmware
end

# Example: Adds '172.18.6.6' to 'Scope1' and 'Scope2'
# Available only in Api300 and Api500
oneview_server_hardware hardware do
  client my_client
  scopes ['Scope1','Scope2']
  action :add_to_scopes
  only_if { client[:api_version] == 300 || client[:api_version] == 500 }
end

# Example: Removes '172.18.6.6' from 'Scope1'
# Available only in Api300 and Api500
oneview_server_hardware hardware do
  client my_client
  scopes ['Scope1']
  action :remove_from_scopes
  only_if { client[:api_version] == 300 || client[:api_version] == 500 }
end

# Example: Replaces 'Scope1' and 'Scope2' for '172.18.6.6'
# Available only in Api300 and Api500
oneview_server_hardware hardware do
  client my_client
  scopes ['Scope1', 'Scope2']
  action :replace_scopes
  only_if { client[:api_version] == 300 || client[:api_version] == 500 }
end

# Example: Replaces all scopes to empty list of scopes
# Available only in Api300 and Api500
oneview_server_hardware hardware do
  client my_client
  operation 'replace'
  path '/scopeUris'
  value []
  action :patch
  only_if { client[:api_version] == 300 || client[:api_version] == 500 }
end

# Remove operation will work only for C7000
# Example: Remove the server hardware from OneView
oneview_server_hardware hardware do
  client my_client
  action :remove
  only_if { client[:api_variant] == 'C7000' }
end
