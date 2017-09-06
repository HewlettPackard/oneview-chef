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

# API200
property :enclosure_group, String # Name of Enclosure Group
property :refresh_state, String, default: 'RefreshPending'
property :options, Hash, default: {}
property :scopes, Array # API300 or greater

default_action :add

action :add do
  OneviewCookbook::Helper.do_resource_action(self, :Enclosure, :add_or_edit)
end

action :remove do
  OneviewCookbook::Helper.do_resource_action(self, :Enclosure, :remove)
end

action :reconfigure do
  OneviewCookbook::Helper.do_resource_action(self, :Enclosure, :reconfigure)
end

action :refresh do
  OneviewCookbook::Helper.do_resource_action(self, :Enclosure, :refresh)
end

action :patch do
  OneviewCookbook::Helper.do_resource_action(self, :Enclosure, :patch)
end

action :add_to_scopes do
  OneviewCookbook::Helper.do_resource_action(self, :Enclosure, :add_to_scopes)
end

action :remove_from_scopes do
  OneviewCookbook::Helper.do_resource_action(self, :Enclosure, :remove_from_scopes)
end

action :replace_scopes do
  OneviewCookbook::Helper.do_resource_action(self, :Enclosure, :replace_scopes)
end
