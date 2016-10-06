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

property :bay_number, Fixnum
property :enclosure, String
property :internal_network_list, Array

default_action :none

action_class do
  include OneviewCookbook::Helper
  include OneviewCookbook::ResourceBase
  def interconnect_handler(present_block, absent_block, item = nil)
    item ||= load_resource
    raise "Unspecified property: 'bay_number'. Please set it before attempting this action." unless bay_number
    raise "Unspecified property: 'enclosure'. Please set it before attempting this action." unless enclosure
    interconnect_list = OneviewSDK::Interconnect.find_by(item.client, {})
    enclosure_item = OneviewSDK::Enclosure.find_by(item.client, name: enclosure).first
    # Procedure to get (bay, enclosure) pairs and interconnect state
    listed_pairs = {}
    interconnect_list.each do |inter|
      bayn = inter['interconnectLocation']['locationEntries'].select { |e| e['type'] == 'Bay' }.first['value']
      encn = inter['interconnectLocation']['locationEntries'].select { |e| e['type'] == 'Enclosure' }.first['value']
      listed_pairs[[bayn, encn]] = inter['state']
    end
    # Desired (bay, enclosure) interconnect location
    pair = [bay_number.to_s, enclosure_item['uri']]
    # If an interconnect exists in the location, and its state is not 'Absent', so it is present
    if listed_pairs.keys.include?(pair) && listed_pairs[pair] != 'Absent'
      present_block.call(bay_number, enclosure_item)
    else
      absent_block.call(bay_number, enclosure_item)
    end
  end

  def update_handler(action, key = nil, item = nil, temp = nil)
    item ||= load_resource
    temp ||= if key
               { key.to_s => Marshal.load(Marshal.dump(item[key])) }
             else
               Marshal.load(Marshal.dump(item.data))
             end
    raise "Resource not found: Action '#{action}' cannot be performed since #{resource_name} '#{name}' was not found." unless item.exists?
    item.retrieve!
    return Chef::Log.info("#{resource_name} '#{name}' is up to date") if item.like?(temp)
    Chef::Log.info "#{action.to_s.capitalize.tr('_', ' ')} #{resource_name} '#{name}'"
    Chef::Log.debug "#{resource_name} '#{name}' Chef resource differs from OneView resource."
    Chef::Log.debug "Current state: #{JSON.pretty_generate(item.data)}"
    Chef::Log.debug "Desired state: #{JSON.pretty_generate(temp)}"
    diff = get_diff(item, temp)
    temp[key].each { |k, v| item[key][k] = v } if key
    converge_by "#{action.to_s.capitalize.tr('_', ' ')} #{resource_name} '#{name}'#{diff}" do
      item.send(action)
    end
  end
end

action :none do
end

action :add_interconnect do
  item = load_resource
  noaction = proc do
    Chef::Log.info("Interconnect already created in #{enclosure} at bay #{bay_number}")
  end
  do_add = proc do |bay, enc|
    converge_by "Add interconnect in #{enclosure} at bay #{bay_number}" do
      item.create(bay, enc)
    end
  end
  interconnect_handler(noaction, do_add, item)
end

action :remove_interconnect do
  item = load_resource
  do_remove = proc do |bay, enc|
    converge_by "Remove interconnect in #{enclosure} at bay #{bay_number}" do
      item.delete(bay, enc)
    end
  end
  noaction = proc do
    Chef::Log.info("Interconnect not present in #{enclosure} at bay #{bay_number}")
  end
  interconnect_handler(do_remove, noaction, item)
end

action :update_internal_networks do
  item = load_resource
  internal_network_list.collect! { |n| OneviewSDK::EthernetNetwork.new(item.client, name: n) }
  item.retrieve!
  if item['internalNetworkUris'].sort == internal_network_list.sort
    Chef::Log.info("Internal networks for #{resource_name} #{name} are up to date")
  else
    diff = get_diff(item, 'internalNetworkUris' => internal_network_list)
    converge_by("Update internal networks for #{resource_name} '#{name}'#{diff}") do
      item.update_internal_networks(*internal_network_list)
    end
  end
end

action :update_settings do
  update_handler(:update_settings)
end

action :update_ethernet_settings do
  update_handler(:update_ethernet_settings, 'ethernetSettings')
end

action :rogue do
  item = load_resource
  item.retrieve!
  item['ethernetSettings']['igmpIdleTimeoutInterval'] = 750
  converge_by 'Action update_ethernet_settings test' do
    item.update_ethernet_settings
  end
end

action :update_port_monitor do
  update_handler(:update_ethernet_settings, 'portMonitor')
end

action :update_qos_configuration do
  update_handler(:update_qos_configuration, 'qosConfiguration')
end

action :update_telemetry_configuration do
  update_handler(:update_telemetry_configuration, 'telemetryConfiguration')
end

action :update_snmp_configuration do
  update_handler(:update_snmp_configuration, 'snmpConfiguration')
end

action :update_firmware do
  # TODO
end

action :update_from_group do
  item = load_resource
  item.retrieve!
  # Nothing to verify
  converge_by "Update #{resource_name} '#{name}' from group" do
    item.compliance
  end
end

action :reapply_configuration do
  item = load_resource
  item.retrieve!
  # Nothing to verify
  converge_by "Reapply configuration in #{resource_name} '#{name}'" do
    item.configuration
  end
end
