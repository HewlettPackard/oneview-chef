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

OneviewCookbook::ResourceBaseProperties.load(self)

default_action :create

action_class do
  include OneviewCookbook::Helper
  include OneviewCookbook::ResourceBase
end

action :create do
  create_or_update
end

action :create_if_missing do
  create_if_missing
end

action :delete do
  delete
end

action :bulk_create do
  load_sdk
  connection = build_client(client)
  formatted_data = convert_keys(data, :to_sym)
  formatted_data[:namePrefix] ||= name
  converge_by "Creating #{resource_name} '#{name}' within the range #{formatted_data[:vlanIdRange]}" do
    OneviewSDK::EthernetNetwork.bulk_create(connection, formatted_data)
  end
end
