#
# Cookbook Name:: oneview_test
# Recipe:: managed_san_set_policy
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

oneview_managed_san 'ManagedSAN1' do
  client node['oneview_test']['client']
  data(
    sanPolicy: {
      zoningPolicy: 'SingleInitiatorAllTargets',
      zoneNameFormat: '{hostName}_{initiatorWwn}',
      enableAliasing: true,
      initiatorNameFormat: '{hostName}_{initiatorWwn}',
      targetNameFormat: '{storageSystemName}_{targetName}',
      targetGroupNameFormat: '{storageSystemName}_{targetGroupName}'
    }
  )
  action :set_policy
end
