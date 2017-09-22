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

property :username, String
property :password, String
property :uid_state, [String, Symbol], regex: /^(on|off)$/i                   # Used in :set_power_state action only
property :power_state, [String, Symbol], regex: /^(on|off)$/i                 # Used in :set_uid_state action only
property :refresh_options, Hash, default: { refreshState: 'RefreshPending' }  # Used in :refresh action only
property :auto_import_certificate, [TrueClass, FalseClass], default: true     # Used in :discover action only

default_action :add

action :add do
  OneviewCookbook::Helper.do_resource_action(self, :PowerDevice, :add_or_edit)
end

action :add_if_missing do
  OneviewCookbook::Helper.do_resource_action(self, :PowerDevice, :add_if_missing)
end

action :discover do
  OneviewCookbook::Helper.do_resource_action(self, :PowerDevice, :discover)
end

action :remove do
  OneviewCookbook::Helper.do_resource_action(self, :PowerDevice, :remove)
end

action :refresh do
  OneviewCookbook::Helper.do_resource_action(self, :PowerDevice, :refresh)
end

action :set_uid_state do
  OneviewCookbook::Helper.do_resource_action(self, :PowerDevice, :set_uid_state)
end

action :set_power_state do
  OneviewCookbook::Helper.do_resource_action(self, :PowerDevice, :set_power_state)
end
