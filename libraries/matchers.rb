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

if defined?(ChefSpec)
  # Instead of defining each matcher method, we're going to save some time by doing some meta programming
  # To see a full list of the actual matchers, see spec/unit/resources/matchers_spec.rb
  standard_actions = [:create, :create_if_missing, :delete]
  # Lists all the possible action verbs
  action_list = %w(create add delete remove set reset refresh update configure reconfigure)
  oneview_resources = {
    oneview_resource:                   standard_actions,
    oneview_connection_template:        [:update, :reset],
    oneview_datacenter:                 [:add, :remove, :add_if_missing],
    oneview_enclosure:                  [:add, :remove, :refresh, :reconfigure],
    oneview_enclosure_group:            standard_actions + [:set_script],
    oneview_ethernet_network:           standard_actions + [:bulk_create, :reset_connection_template],
    oneview_fc_network:                 standard_actions,
    oneview_fcoe_network:               standard_actions,
    oneview_firmware_bundle:            [:add],
    oneview_interconnect:               [:set_uid_light, :set_power_state, :reset, :reset_port_protection, :update_port],
    oneview_logical_enclosure:          [:update_from_group, :reconfigure, :set_script],
    oneview_logical_interconnect_group: standard_actions,
    oneview_logical_switch_group:       standard_actions,
    oneview_network_set:                standard_actions,
    oneview_rack:                       [:add, :remove, :add_if_missing, :add_to_rack, :remove_from_rack],
    oneview_server_hardware:            [:add_if_missing, :remove, :refresh, :set_power_state, :update_ilo_firmware],
    oneview_storage_pool:               [:add, :remove],
    oneview_storage_system:             [:add, :remove],
    oneview_volume:                     standard_actions,
    oneview_volume_template:            standard_actions
  }

  oneview_resources.each do |resource_type, actions|
    actions.each do |action|
      # Each action should follow <action_clause>_<resource_type>[_<object_complement>] naming standards
      description = action.to_s.split('_')
      # Finds the last action cited in the action description
      action_indexes = action_list.map { |action_word| description.rindex(action_word) }
      last_action_index = action_indexes.compact.max
      # Inserts the resource type after the action
      description.insert(last_action_index + 1, resource_type.to_s)
      # Rejoin everything
      method_name = description.join('_')

      define_method(method_name) do |resource_name|
        ChefSpec::Matchers::ResourceMatcher.new(resource_type, action, resource_name)
      end
    end
  end
end
