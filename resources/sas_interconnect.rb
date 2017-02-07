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

property :uid_light_state, String
property :power_state, String
property :refresh_state, String, default: 'RefreshPending'

default_action :none

action :none do
end

action :hard_reset do
  OneviewCookbook::Helper.do_resource_action(self, :SASInterconnect, :hard_reset)
end

action :patch do
  OneviewCookbook::Helper.do_resource_action(self, :SASInterconnect, :patch)
end

action :refresh do
  OneviewCookbook::Helper.do_resource_action(self, :SASInterconnect, :refresh)
end

action :reset do
  OneviewCookbook::Helper.do_resource_action(self, :SASInterconnect, :reset)
end

action :set_power_state do
  OneviewCookbook::Helper.do_resource_action(self, :SASInterconnect, :set_power_state)
end

action :set_uid_light do
  OneviewCookbook::Helper.do_resource_action(self, :SASInterconnect, :set_uid_light)
end
