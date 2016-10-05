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
  def interconnect_handler(present_block, absent_block)
    item = load_resource
    raise "Unspecified property: 'bay_number'. Please set it before attempting this action." unless bay_number
    raise "Unspecified property: 'enclosure'. Please set it before attempting this action." unless enclosure
    interconnect_list = OneviewSDK::Interconnect.find_by(@client, {})
    # Procedure to get (bay, enclosure) pairs
    get_pair = Proc.new do |inter|
      bayn = inter['interconnectLocation']['locationEntries'].select { |e| e['type'] == 'Bay' }['value']
      encn = inter['interconnectLocation']['locationEntries'].select { |e| e['type'] == 'Enclosure' }['value']
      [bayn, encn]
    end
    enclosure_item = OneviewSDK::Enclosure.find_by(item.client, name: enclosure)
    # Checks if the list contains an pair that matches the one described
    if interconnect_list.collect(&:get_pair).include?([bay_number, enclosure_item['uri'])
      present_block.call
    else
      absent_block.call
    end
  end

  def update_handler(action, key = nil, item = nil, temp = nil)
    item ||= load_resource
    temp ||= if key
               key.to_s => Marshal.load(Marshal.dump(item[key]))
             else
               Marshal.load(Marshal.dump(item.data))
             end
    if item.exists?
      item.retrieve!
      if item.like? temp
        Chef::Log.info("#{resource_name} '#{name}' is up to date")
      else
        Chef::Log.info "#{action.to_s.capitalize.gsub('_', ' ')} #{resource_name} '#{name}'"
        Chef::Log.debug "#{resource_name} '#{name}' Chef resource differs from OneView resource."
        Chef::Log.debug "Current state: #{JSON.pretty_generate(item.data)}"
        Chef::Log.debug "Desired state: #{JSON.pretty_generate(temp)}"
        diff = get_diff(item, temp)
        converge_by "#{action.to_s.capitalize.gsub('_', ' ')} #{resource_name} '#{name}'#{diff}" do
          item.update(temp)
        end
      end
    else
      raise "Resource not found: Action '#{action}' cannot be performed since #{resource_name} '#{name}' was not found."
    end
  end
end

action :none do
end

action :create_interconnect do
  noaction = { Chef::Log.info("Interconnect already created in #{enclosure} at bay #{bay_number}") }
  do_create = do
    converge_by "Create interconnect in #{enclosure} at bay #{bay_number}"
      item.create(bay_number, enclosure_item)
    end
  end
  interconnect_handler(noaction, do_create)
end

action :delete_interconnect do
  do_delete = do
    converge_by "Delete interconnect in #{enclosure} at bay #{bay_number}" do
      item.delete(bay_number, enclosure_item)
    end
  end
  noaction = { Chef::Log.info("Interconnect not present in #{enclosure} at bay #{bay_number}") }
  interconnect_handler(do_delete, noaction)
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

action :update_port_monitor do
  update_handler(:update_ethernet_settings, 'ethernetSettings')
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
