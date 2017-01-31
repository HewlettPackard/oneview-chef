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

property :port_options, Hash
property :uid_light_state, String
property :power_state, String

default_action :none

action :none do
end

action :set_uid_light do
  OneviewCookbook::Helper.do_resource_action(self, :Interconnect, :set_uid_light)
end

action :set_power_state do
  OneviewCookbook::Helper.do_resource_action(self, :Interconnect, :set_power_state)
end

action :reset do
  OneviewCookbook::Helper.do_resource_action(self, :Interconnect, :reset)
end

action :reset_port_protection do
  OneviewCookbook::Helper.do_resource_action(self, :Interconnect, :reset_port_protection)
end

action :update_port do
  OneviewCookbook::Helper.do_resource_action(self, :Interconnect, :update_port)
end
