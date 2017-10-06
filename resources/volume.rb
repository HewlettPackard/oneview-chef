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
property :storage_pool, String
property :volume_template, String
property :snapshot_pool, String
property :snapshot_data, Hash
property :properties, Hash
property :is_permanent, [TrueClass, FalseClass], default: true
property :delete_from_appliance_only, [TrueClass, FalseClass], default: false

default_action :create

action :create do
  OneviewCookbook::Helper.do_resource_action(self, :Volume, :create_or_update)
end

action :create_if_missing do
  OneviewCookbook::Helper.do_resource_action(self, :Volume, :create_if_missing)
end

action :delete do
  OneviewCookbook::Helper.do_resource_action(self, :Volume, :delete)
end

action :create_snapshot do
  OneviewCookbook::Helper.do_resource_action(self, :Volume, :create_snapshot)
end

action :delete_snapshot do
  OneviewCookbook::Helper.do_resource_action(self, :Volume, :delete_snapshot)
end

action :create_from_snapshot do
  OneviewCookbook::Helper.do_resource_action(self, :Volume, :create_from_snapshot)
end

action :add_if_missing do
  OneviewCookbook::Helper.do_resource_action(self, :Volume, :add_if_missing)
end
