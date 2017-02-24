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

my_client = {
  url: ENV['ONEVIEWSDK_URL'],
  user: ENV['ONEVIEWSDK_USER'],
  password: ENV['ONEVIEWSDK_PASSWORD']
}

# Example: default action is none
oneview_managed_san 'SAN1_0' do
  client my_client
end

# Example: Refreshes Managed SAN
oneview_managed_san 'SAN1_0' do
  client my_client
  action :refresh
end

# Example: set managed san policy
oneview_managed_san 'SAN1_0' do
  client my_client
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

# Example: set managed san public attributes
oneview_managed_san 'SAN1_0' do
  client my_client
  data(
    publicAttributes: [
      {
        name: 'MetaSan',
        value: 'Neons SAN',
        valueType: 'String',
        valueFormat: 'None'
      }
    ]
  )
  action :set_public_attributes
end
