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

property :storage_system, String

default_action :add_if_missing

action_class do
  include OneviewCookbook::Helper
  include OneviewCookbook::ResourceBase
end

action :add_if_missing do
  raise "Unspecified property: 'storage_system'. Please set it before attempting this action." unless storage_system
  item = load_resource
  item['poolName'] ||= name

  storage_system_resource = OneviewSDK::StorageSystem.new(item.client, credentials: { ip_hostname: storage_system })
  unless storage_system_resource.exists?
    storage_system_resource = OneviewSDK::StorageSystem.new(item.client, name: storage_system)
  end

  storage_system_resource.retrieve!
  item.set_storage_system(storage_system_resource)
  add_if_missing(item)
end

action :remove do
  remove
end
