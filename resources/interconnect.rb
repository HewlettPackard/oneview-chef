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

property :port_options, Hash
property :uid_light_state, String
property :power_state, String

default_action :none

action_class do
  include OneviewCookbook::Helper
  include OneviewCookbook::ResourceBase
end

action :none do
end

action :set_uid_light do
  raise "Unspecified property: 'uid_light_state'. Please set it before attempting this action." unless uid_light_state
  item = load_resource
  item.retrieve!
  # Impossible to verify this value programatically
  converge_by "Set #{resource_name} '#{name}' UID light to #{uid_light_state.upcase}" do
    item.patch('replace', '/uidState', uid_light_state.capitalize)
  end
end

action :set_power_state do
  raise "Unspecified property: 'power_state'. Please set it before attempting this action." unless power_state
  item = load_resource
  item.retrieve!
  if item['powerState'] != power_state
    converge_by "Power #{resource_name} '#{name}' #{power_state.upcase}" do
      item.patch('replace', '/powerState', power_state.capitalize)
    end
  else
    Chef::Log.info("#{resource_name} '#{name}' is already powered #{power_state.upcase}")
  end
end

action :reset do
  item = load_resource
  item.retrieve!
  # Nothing to verify
  converge_by "Reset #{resource_name} '#{name}'" do
    item.patch('replace', '/deviceResetState', 'Reset')
  end
end

action :reset_port_protection do
  item = load_resource
  item.retrieve!
  # Nothing to verify
  converge_by "Reset #{resource_name} '#{name}' port protection" do
    item.reset_port_protection
  end
end

action :update_port do
  raise "Unspecified property: 'port_options'. Please set it before attempting this action." unless port_options
  parsed_port_options = convert_keys(port_options, :to_s)
  raise "Required value \"name\" for 'port_options' not specified" unless parsed_port_options['name']
  item = load_resource
  raise "#{resource_name} '#{item['name']}' not found!" unless item.retrieve!
  target_port = (item['ports'].select { |port| port['name'] == parsed_port_options['name'] }).first
  raise "Could not find port: #{parsed_port_options['name']}" unless target_port
  # Update only if there are options that differ from the current ones
  if parsed_port_options.any? { |k, v| target_port[k] != v }
    diff = get_diff(target_port, parsed_port_options)
    converge_by "Update #{resource_name} '#{name}' port #{parsed_port_options['name']}.#{diff}" do
      item.update_port(parsed_port_options['name'], parsed_port_options)
    end
  else
    Chef::Log.info("#{resource_name} '#{name}' port #{parsed_port_options['name']} is up to date.")
  end
end
