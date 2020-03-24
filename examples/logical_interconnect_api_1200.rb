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


my_client = {
  url: ENV['ONEVIEWSDK_URL'],
  user: ENV['ONEVIEWSDK_USER'],
  password: ENV['ONEVIEWSDK_PASSWORD'],
  api_version: 1200
}

# No action
oneview_logical_interconnect 'test_chef-test_chef' do
  client my_client
end

# Set the EthernetNetwork1 and EthernetNetwork2 as internal networks for the logical interconnect
oneview_logical_interconnect 'test_chef-test_chef' do
  client my_client
  internal_networks ['EthernetNetwork1_15', 'EthernetNetwork1_13']
  action :update_internal_networks
end

# Increase the ethernet settings refresh and timeout intervals
oneview_logical_interconnect 'test_chef-test_chef' do
  client my_client
  data(
    ethernetSettings: {
      igmpIdleTimeoutInterval: 230,
      macRefreshInterval: 15
    }
  )
  action :update_ethernet_settings
end

# Activate the port monitor service
oneview_logical_interconnect 'test_chef-test_chef' do
  client my_client
  port_monitor(
    analyzerPort: {
      portName: 'd1',
      portMonitorConfigInfo: 'AnalyzerPort'
    },
    enablePortMonitor: true,
    type: 'port-monitorV1',
    monitoredPorts: [
      {
        portName: 'd3',
        portMonitorConfigInfo: 'MonitoredBoth'
      }
    ]
  )
  action :update_port_monitor
end

# Disable the port monitor service
oneview_logical_interconnect 'test_chef-test_chef' do
  client my_client
  port_monitor(
    analyzerPort: nil,
    enablePortMonitor: false,
    type: 'port-monitorV1',
    monitoredPorts: []
  )
  action :update_port_monitor
end

# Activate the port monitor service with data
oneview_logical_interconnect 'test_chef-test_chef' do
  client my_client
  data(
    portMonitor: {
      analyzerPort: {
        portUri: '/rest/interconnects/b9e993a0-9023-43b3-8538-51e9ac8f12b1/ports/b9e993a0-9023-43b3-8538-51e9ac8f12b1:d1',
        portMonitorConfigInfo: 'AnalyzerPort'
      },
      enablePortMonitor: true,
      type: 'port-monitorV1',
      monitoredPorts: [
        {
          portUri: '/rest/interconnects/b9e993a0-9023-43b3-8538-51e9ac8f12b1/ports/b9e993a0-9023-43b3-8538-51e9ac8f12b1:d3',
          portMonitorConfigInfo: 'MonitoredBoth'
        }
      ]
    }
  )
  action :update_port_monitor
end

# Disable the port monitor service with data
oneview_logical_interconnect 'test_chef-test_chef' do
  client my_client
  data(
    portMonitor: {
      analyzerPort: nil,
      enablePortMonitor: false,
      type: 'port-monitorV1',
      monitoredPorts: []
    }
  )
  action :update_port_monitor
end

# Activate the port monitor service with data and port_monitor property
oneview_logical_interconnect 'test_chef-test_chef' do
  client my_client
  data(
    portMonitor: {
      analyzerPort: {
        portUri: '/rest/interconnects/b9e993a0-9023-43b3-8538-51e9ac8f12b1/ports/b9e993a0-9023-43b3-8538-51e9ac8f12b1:d1',
        portMonitorConfigInfo: 'AnalyzerPort'
      },
      enablePortMonitor: true,
      type: 'port-monitorV1'
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
oneview_logical_interconnect 'test_chef-test_chef' do
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
oneview_logical_interconnect 'test_chef-test_chef' do
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
oneview_logical_interconnect 'test_chef-test_chef' do
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
oneview_logical_interconnect 'test_chef-test_chef' do
  client my_client
  data(
    snmpConfiguration: {
      snmpAccess: []
    }
  )
  action :update_snmp_configuration
end

# Stage one firmware bundle in the Logical Interconnect with sme flahsing options
oneview_logical_interconnect 'test_chef-test_chef' do
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
oneview_logical_interconnect 'test_chef-test_chef' do
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
oneview_logical_interconnect 'test_chef-test_chef' do
  client my_client
  firmware 'ROM Flash - SPP'
  firmware_data(
    force: false
  )
  action :activate_firmware
end

# Start to reapply the configuration in each managed interconnect
oneview_logical_interconnect 'test_chef-test_chef' do
  client my_client
  action :reapply_configuration
end

# Compliance update
# Update the logical interconnect according to its associated logical interconnect group
oneview_logical_interconnect 'test_chef-test_chef' do
  client my_client
  action :update_from_group
end
