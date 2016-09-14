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

property :power_state, String
property :options, Hash

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

action :remove do
  remove
end

action :update_ilo_firmware do
  item = load_resource
  item.retrieve!
  converge_by "Updating iLO firmware #{resource_name} '#{name}'" do
    item.update_ilo_firmware
  end
end

action :set_power_state do
  raise "Unspecified property: 'power_state'. Please set it before attempting this action." unless power_state
  raise "Invalid property: 'power_state'." unless ['ON', 'OFF'].include? power_state.upcase
  item = load_resource
  item.retrieve!
  if item['powerState'] != power_state
    converge_by "Powering #{resource_name} '#{name}'#{power_state.upcase}" do
      item.public_send("power_#{power_state.downcase}".to_sym)
    end
  else
    Chef::Log.info("#{resource_name} '#{name}' is already powered #{power_state.upcase}")
  end
end

action :refresh do
  item = load_resource
  item.retrieve!

  refresh_state = state || 'RefreshPending'
  refresh_options = options || {}

  if ['RefreshFailed', 'NotRefreshing', ''].include? item['refreshState']
    converge_by "#{resource_name} '#{name}' was refreshed." do
      item.set_refresh_state(refresh_state, refresh_options)
    end
  else
    Chef::Log.info("#{resource_name} '#{name}' refresh is already running.")
  end
end
