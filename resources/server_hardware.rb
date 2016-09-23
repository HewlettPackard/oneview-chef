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

property :power_state, [String, Symbol], regex: /^(on|off)$/i # Used in :set_power_state action only
property :refresh_options, Hash, default: {}                  # Used in :refresh action only

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
  converge_by "Updating iLO firmware on #{resource_name} '#{item['name']}'" do
    item.update_ilo_firmware
  end
end

action :set_power_state do
  raise "Unspecified property: 'power_state'. Please set it before attempting this action." unless power_state
  ps = power_state.to_s.downcase
  item = load_resource
  raise "#{resource_name} '#{item['name']}' not found!" unless item.retrieve!
  if item['powerState'].casecmp(ps) == 0
    Chef::Log.info("#{resource_name} '#{item['name']}' is already powered #{ps}")
  else
    converge_by "Power #{ps} #{resource_name} '#{item['name']}'" do
      item.public_send("power_#{ps}".to_sym)
    end
  end
end

action :refresh do
  item = load_resource
  raise "#{resource_name} '#{item['name']}' not found!" unless item.retrieve!

  if ['RefreshFailed', 'NotRefreshing', ''].include? item['refreshState']
    converge_by "Refresh #{resource_name} '#{item['name']}'." do
      item.set_refresh_state('RefreshPending', refresh_options)
    end
  else
    Chef::Log.info("#{resource_name} '#{item['name']}' refresh is already running.")
  end
end
