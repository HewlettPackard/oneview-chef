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

property :old_drive_enclosure, String
property :new_drive_enclosure, String
property :firmware, String
property :firmware_data, Hash, default: {}

default_action :none

action :none do
end

### Resource interactions ###
action :replace_drive_enclosure do
  OneviewCookbook::Helper.do_resource_action(self, :SASLogicalInterconnect, :replace_drive_enclosure)
end

### Firmware Actions ###
action :update_firmware do
  OneviewCookbook::Helper.do_resource_action(self, :SASLogicalInterconnect, :update_firmware)
end

action :stage_firmware do
  OneviewCookbook::Helper.do_resource_action(self, :SASLogicalInterconnect, :stage_firmware)
end

action :activate_firmware do
  OneviewCookbook::Helper.do_resource_action(self, :SASLogicalInterconnect, :activate_firmware)
end

### Compliance and configuration ###
action :update_from_group do
  OneviewCookbook::Helper.do_resource_action(self, :SASLogicalInterconnect, :update_from_group)
end

action :reapply_configuration do
  OneviewCookbook::Helper.do_resource_action(self, :SASLogicalInterconnect, :reapply_configuration)
end
