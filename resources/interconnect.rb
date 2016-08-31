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

action :set_uid_light do
  valid_state = uid_light_state && (uid_light_state.casecmp('on').zero? || uid_light_state.casecmp('off').zero?)
  raise "Invalid Interconnect UID light state: #{uid_light_state}" unless valid_state
  item = load_resource
  item.retrieve!
  # Impossible to verify this value programatically
  converge_by "Setting #{resource_name} '#{name}' UID light to #{uid_light_state.uppercase}" do
    item.patch('replace', '/uidState', uid_light_state.capitalize)
  end
end

action :set_power_state do
  valid_state = power_state && (power_state.casecmp('on').zero? || power_state.casecmp('off').zero?)
  raise "Invalid Interconnect power state: #{power_state}" unless valid_state
  item = load_resource
  item.retrieve!
  if item['powerState'] != power_state
    converge_by "Powering #{resource_name} '#{name}'#{power_state.uppercase}" do
      item.patch('replace', '/powerState', power_state.capitalize)
    end
  else
    Chef::Log.info("#{resource_name} '#{name}' is already powered #{power_state.uppercase}")
  end
end

action :reset do
  item = load_resource
  item.retrieve!
  # Nothing to verify
  converge_by "Resetting #{resource_name} '#{name}'" do
    item.patch('replace', '/deviceResetState', 'Reset')
  end
end

action :reset_port_protection do
  item = load_resource
  item.retrieve!
  # Nothing to verify
  converge_by "Resetting #{resource_name} '#{name}' port protection" do
    item.reset_port_protection
  end
end

action :update_port do
  raise "Unspecified property: 'port_options'" unless port_options
  port_options = convert_keys(port_options, :to_s)
  raise "Required value \"name\" for 'port_options' not specified" unless port_options['name']
  item = load_resource
  item.retrieve!
  port = (item['ports'].select { |port| port['name'] == port_options['name'] } ).first
  raise "Could not find port: #{port_options['name']}" unless port
  # Unless there are no values in new options that differ from the current ones, do the update
  unless (port_options.select { |k,v| port[k] != v } ).empty?
    converge_by "Updating #{resource_name} '#{name}' port #{port_options['name']}." do
      item.update_port(port_options['name'], port_options)
    end
  else
    Chef::Log.info("#{resource_name} '#{name}' port #{port_options['name']} is up to date.")
  end
end
