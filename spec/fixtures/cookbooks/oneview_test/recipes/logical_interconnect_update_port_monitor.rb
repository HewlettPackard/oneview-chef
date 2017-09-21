#
# Cookbook Name:: oneview_test
# Recipe:: logical_interconnect_update_port_monitor
#
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
#

oneview_logical_interconnect 'LogicalInterconnect-update_port_monitor' do
  client node['oneview_test']['client']
  port_monitor(
    analyzerPort: {
      portName: 'Q1:3',
      portMonitorConfigInfo: 'AnalyzerPort'
    },
    enablePortMonitor: true,
    type: 'port-monitor',
    monitoredPorts: [
      {
        portName: 'd1',
        portMonitorConfigInfo: 'MonitoredBoth'
      }
    ]
  )
  action :update_port_monitor
end
