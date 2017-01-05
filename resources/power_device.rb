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
OneviewCookbook::Helper.load_sdk(self)
OneviewCookbook::Helper.load_attributes(self)

property :username, String
property :password, String

default_action :add

action_class do
  include OneviewCookbook::Helper
  include OneviewCookbook::ResourceBase
end

action :add do
  add_or_edit
end

action :add_if_missing do
  add_if_missing
end

action :discover do
  c = build_client(client)
  power_devices_list = OneviewSDK::PowerDevice.get_ipdu_devices(c, name)
  if power_devices_list.empty?
    Chef::Log.info "Discovering #{resource_name} '#{name}'"
    converge_by "Discovered #{resource_name} '#{name}'" do
      OneviewSDK::PowerDevice.discover(c, hostname: name, username: username, password: password)
    end
  else
    Chef::Log.info("#{resource_name} '#{name}' is up to date")
  end
end

action :remove do
  # First try to remove by name, if it does not work it consider the power device is
  # an iPDU
  unless remove
    c = build_client(client)
    power_devices_list = OneviewSDK::PowerDevice.get_ipdu_devices(c, name)
    remove(power_devices_list.first) unless power_devices_list.empty?
  end
end
