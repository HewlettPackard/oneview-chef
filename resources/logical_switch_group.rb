# (c) Copyright 2016-2017 Hewlett Packard Enterprise Development LP
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

property :switch_number, Integer
property :switch_type, String
property :scopes, Array

default_action :create

action :create do
  OneviewCookbook::Helper.do_resource_action(self, :LogicalSwitchGroup, :create_or_update)
end

action :create_if_missing do
  OneviewCookbook::Helper.do_resource_action(self, :LogicalSwitchGroup, :create_if_missing)
end

action :delete do
  OneviewCookbook::Helper.do_resource_action(self, :LogicalSwitchGroup, :delete)
end

action :add_to_scopes do
  OneviewCookbook::Helper.do_resource_action(self, :LogicalSwitchGroup, :add_to_scopes)
end

action :remove_from_scopes do
  OneviewCookbook::Helper.do_resource_action(self, :LogicalSwitchGroup, :remove_from_scopes)
end

action :replace_scopes do
  OneviewCookbook::Helper.do_resource_action(self, :LogicalSwitchGroup, :replace_scopes)
end

action :patch do
  OneviewCookbook::Helper.do_resource_action(self, :LogicalSwitchGroup, :patch)
end
