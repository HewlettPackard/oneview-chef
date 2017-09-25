#
# Cookbook Name:: oneview_test
# Recipe:: logical_interconnect_update_port_monitor_data_and_property
#
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
#

oneview_logical_interconnect 'LogicalInterconnect-update_port_monitor_data_and_property' do
  client node['oneview_test']['client']
  data(
    portMonitor: {
      analyzerPort: {
        portUri: '/rest/fake/Q1:3',
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
