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

OneviewCookbook::ResourceBaseProperties.load(self)

property :script, String # script for set_script action
property :enclosures, Array # List of enclosure names (or serialNumbers or OA IPs) for create & create_if_missing actions
property :enclosure_group, String # Name of enclosure group for create & create_if_missing actions
property :dump_options, Hash # Used in :create_support_dump action only

default_action :create_if_missing

action :create_if_missing do
  OneviewCookbook::Helper.do_resource_action(self, :LogicalEnclosure, :create_if_missing)
end

action :create do
  OneviewCookbook::Helper.do_resource_action(self, :LogicalEnclosure, :create_or_update)
end

action :update_from_group do
  OneviewCookbook::Helper.do_resource_action(self, :LogicalEnclosure, :update_from_group)
end

action :reconfigure do
  OneviewCookbook::Helper.do_resource_action(self, :LogicalEnclosure, :reconfigure)
end

action :set_script do
  OneviewCookbook::Helper.do_resource_action(self, :LogicalEnclosure, :set_script)
end

action :delete do
  OneviewCookbook::Helper.do_resource_action(self, :LogicalEnclosure, :delete)
end

action :create_support_dump do
  OneviewCookbook::Helper.do_resource_action(self, :LogicalEnclosure, :create_support_dump)
end
