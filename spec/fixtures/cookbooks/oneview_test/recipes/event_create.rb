#
# Cookbook Name:: oneview_test
# Recipe:: event_create
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

oneview_event 'Event1' do
  client node['oneview_test']['client']
  data(
    eventTypeID: 'source-test.event-id',
    description: 'This is a very simple test event',
    serviceEventSource: true,
    urgency: 'None',
    severity: 'OK',
    healthCategory: 'PROCESSOR',
    eventDetails: [
      {
        eventItemName: 'ipv4Address',
        eventItemValue: '172.16.10.81',
        isThisVarbindData: false,
        varBindOrderIndex: -1
      }
    ]
  )
end
