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

# NOTE 1: This recipe requires:
# Ethernet Networks: EthernetNetwork1, EthernetNetwork2
# NOTE 2: This example requires two Scopes named "Scope1" and "Scope2" to be present in the appliance.
# NOTE 3: The api_version client should be 300 or greater if you run the examples using Scopes

OneviewCookbook::Helper.load_sdk(self)

my_client = {
  url: ENV['ONEVIEWSDK_URL'],
  user: ENV['ONEVIEWSDK_USER'],
  password: ENV['ONEVIEWSDK_PASSWORD'],
  api_variant: 'Synergy',
  api_version: 2400
}

# No action
oneview_logical_interconnect 'LE-LIG' do
  client my_client
end

# Remove from management the interconnect in the enclosure 'Encl1' in bay 1
# Available only in Api200
oneview_logical_interconnect 'Remove Encl 1, interconnect 1' do
  client my_client
  enclosure 'Encl1'
  bay_number 1
  action :remove_interconnect
  only_if { client[:api_version] == 200 }
end

# Add the interconnect in the enclosure 'Encl1' in bay 1 for management in HPE OneView
# Available only in Api200
oneview_logical_interconnect 'Add Encl 1, interconnect 1' do
  client my_client
  enclosure 'Encl1'
  bay_number 1
  action :add_interconnect
  only_if { client[:api_version] == 200 }
end

# Get the inconsistency report for bulk update from group
oneview_logical_interconnect 'LE-LIG' do
  client my_client
  li = OneviewCookbook::Helper.load_resource(my_client, type: 'LogicalInterconnect', id: 'LE-LIG')
  logicalInterconnectUris [ li['uri'] ]
  action :validate_bulk_inconsistency
end

# Set the EthernetNetwork1 and EthernetNetwork2 as internal networks for the logical interconnect
oneview_logical_interconnect 'LE-LIG' do
  client my_client
  internal_networks ['Test1', 'Test2']
  action :update_internal_networks
end

# Increase the ethernet settings refresh and timeout intervals
oneview_logical_interconnect 'LE-LIG' do
  client my_client
  if client[:api_variant] == 'C7000'
    data(
    	ethernetSettings: {
      	igmpIdleTimeoutInterval: 230,
      	macRefreshInterval: 30
    	}
    )
  end
  if client[:api_variant] == 'Synergy'
	  data(
        ethernetSettings: {
        igmpIdleTimeoutInterval: 230,
        stormControlPollingInterval: 20
        }
    )
  end
  action :update_ethernet_settings
end

# Update igmp  settings refresh and timeout intervals
oneview_logical_interconnect 'LE-LIG' do
  client my_client
  data(
    igmpSettings: {
      igmpIdleTimeoutInterval: 230,
    }
  )
  action :update_igmp_settings
end

# Update igmp  settings refresh and timeout intervals
oneview_logical_interconnect 'LE-LIG' do
  client my_client
  data(
    portFlapProtection: {
      portFlapThresholdPerInterval: 10,
    }
  )
  action :update_port_flap_settings
end

interconnect = OneviewCookbook::Helper.load_resource(my_client, type: 'Interconnect', id: '0000A66101, interconnect 3')
ports = interconnect['ports']
uplink_port = nil
downlink_port = nil
uplink_port_name = nil
downlink_port_name = nil
ports.each do |port|
   if port['portType'] == 'Uplink'
      uplink_port = port['uri']
      uplink_port_name = port['portName']
   end
   if port['portType'] == 'Downlink'
      downlink_port = port['uri']
      downlink_port_name = port['portName']
   end
end

# Activate the port monitor service
oneview_logical_interconnect 'LE-LIG' do
  client my_client
  port_monitor(
    analyzerPort: {
      portName: uplink_port_name,
      portMonitorConfigInfo: 'AnalyzerPort'
    },
    enablePortMonitor: true,
    type: 'port-monitor',
    monitoredPorts: [
      {
        portName: downlink_port_name,
        portMonitorConfigInfo: 'MonitoredBoth'
      }
    ]
  )
  action :update_port_monitor
end

# Disable the port monitor service
oneview_logical_interconnect 'LE-LIG' do
  client my_client
  port_monitor(
    analyzerPort: nil,
    enablePortMonitor: false,
    type: 'port-monitor',
    monitoredPorts: []
  )
  action :update_port_monitor
end

# Activate the port monitor service with data
oneview_logical_interconnect 'LE-LIG' do
  client my_client
  data(
    portMonitor: {
      analyzerPort: {
	portUri: uplink_port,
        portMonitorConfigInfo: 'AnalyzerPort'
      },
      enablePortMonitor: true,
      type: 'port-monitor',
      monitoredPorts: [
        {
          portUri: downlink_port,
          portMonitorConfigInfo: 'MonitoredBoth'
        }
      ]
    }
  )
  action :update_port_monitor
end

# Disable the port monitor service with data
oneview_logical_interconnect 'LE-LIG' do
  client my_client
  data(
    portMonitor: {
      analyzerPort: nil,
      enablePortMonitor: false,
      type: 'port-monitor',
      monitoredPorts: []
    }
  )
  action :update_port_monitor
end

# Activate the port monitor service with data and port_monitor property
oneview_logical_interconnect 'LE-LIG' do
  client my_client
  data(
    portMonitor: {
      analyzerPort: {
	      portUri: uplink_port,
        portMonitorConfigInfo: 'AnalyzerPort'
      },
      enablePortMonitor: true,
      type: 'port-monitor'
    }
  )
  port_monitor(
    monitoredPorts: [
      {
        portName: 'd1',
        portMonitorConfigInfo: 'MonitoredBoth'
      }
    ]
  )
  action :update_port_monitor
end

# Update quality of service configuration
oneview_logical_interconnect 'LE-LIG' do
  client my_client
  data(
    qosConfiguration: {
      activeQosConfig: {
        configType: 'Passthrough',
        description: 'Configured by chef-oneview'
      }
    }
  )
  action :update_qos_configuration
end

# Update telemetry configuration
oneview_logical_interconnect 'LE-LIG' do
  client my_client
  data(
    telemetryConfiguration: {
      sampleCount: 25,
      sampleInterval: 225
    }
  )
  action :update_telemetry_configuration
end

# Add one SNMP Trap configuration
oneview_logical_interconnect 'LE-LIG' do
  client my_client
  data(
    snmpConfiguration: {
      snmpAccess: ['172.18.6.15/24']
    }
  )
  trap_destinations(
    '172.18.6.16' => {
      trapFormat: 'SNMPv1',
      communityString: 'public',
      severities: ['Critical', 'Major', 'Unknown'],
      vcmTraps: ['Legacy'],
      enetTraps: ['PortStatus', 'PortThresholds'],
      fcTraps: ['Other']
    }
  )
  action :update_snmp_configuration
end

# Clean the SNMP Traps
oneview_logical_interconnect 'LE-LIG' do
  client my_client
  data(
    snmpConfiguration: {
      snmpAccess: []
    }
  )
  action :update_snmp_configuration
end

# Stage one firmware bundle in the Logical Interconnect with sme flahsing options
oneview_logical_interconnect 'LE-LIG' do
  client my_client
  firmware 'ROM Flash - SPP'
  firmware_data(
    ethernetActivationDelay: 10,
    ethernetActivationType: 'OddEven',
    fcActivationDelay: 10,
    fcActivationType: 'Serial',
    force: false
  )
  action :stage_firmware
end

# Update the staged firmware driver flahsing options
oneview_logical_interconnect 'LE-LIG' do
  client my_client
  firmware 'ROM Flash - SPP'
  firmware_data(
    ethernetActivationDelay: 15,
    fcActivationDelay: 20,
    force: true
  )
  action :update_firmware
end

# Activate the staged firmware in the logical interconnect
# It starts the flashing process in each managed interconnect
oneview_logical_interconnect 'LE-LIG' do
  client my_client
  firmware 'ROM Flash - SPP'
  firmware_data(
    force: false
  )
  action :activate_firmware
end

# Start to reapply the configuration in each managed interconnect
oneview_logical_interconnect 'LE-LIG' do
  client my_client
  action :reapply_configuration
end

# Compliance update
# Update the logical interconnect according to its associated logical interconnect group
oneview_logical_interconnect 'LE-LIG' do
  client my_client
  action :update_from_group
end

# Example: Adds 'LE-LIG' to 'Scope1' and 'Scope2'
# Available only in Api300 and Api500
oneview_logical_interconnect 'LE-LIG' do
  client my_client
  scopes ['Scope1', 'Scope2']
  action :add_to_scopes
  only_if { client[:api_version] == 300 || client[:api_version] == 500 }
end

# Example: Removes 'LE-LIG' from 'Scope1'
# Available only in Api300 and Api500
oneview_logical_interconnect 'LE-LIG' do
  client my_client
  scopes ['Scope1']
  action :remove_from_scopes
  only_if { client[:api_version] == 300 || client[:api_version] == 500 }
end

# Example: Replaces 'Scope1' and 'Scope2' for 'LE-LIG'
# Available only in Api300 and Api500
oneview_logical_interconnect 'LE-LIG' do
  client my_client
  scopes ['Scope1', 'Scope2']
  action :replace_scopes
  only_if { client[:api_version] == 300 || client[:api_version] == 500 }
end

# Example: Replaces all scopes to empty list of scopes
# Available only in Api300 and Api500
oneview_logical_interconnect 'LE-LIG' do
  client my_client
  operation 'replace'
  path '/scopeUris'
  value []
  action :patch
  only_if { client[:api_version] == 300 || client[:api_version] == 500 }
end
