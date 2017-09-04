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

property :associated_san, String
property :scopes, Array

action :create do
  OneviewCookbook::Helper.do_resource_action(self, :FCNetwork, :create_or_update)
end

action :create_if_missing do
  OneviewCookbook::Helper.do_resource_action(self, :FCNetwork, :create_if_missing)
end

action :delete do
  OneviewCookbook::Helper.do_resource_action(self, :FCNetwork, :delete)
end

action :add_to_scopes do
  OneviewCookbook::Helper.do_resource_action(self, :FCNetwork, :add_to_scopes)
end

action :remove_from_scopes do
  OneviewCookbook::Helper.do_resource_action(self, :FCNetwork, :remove_from_scopes)
end

action :replace_scopes do
  OneviewCookbook::Helper.do_resource_action(self, :FCNetwork, :replace_scopes)
end

action :patch do
  OneviewCookbook::Helper.do_resource_action(self, :FCNetwork, :patch)
end

action :reset_connection_template do
  OneviewCookbook::Helper.do_resource_action(self, :FCNetwork, :reset_connection_template)
end
