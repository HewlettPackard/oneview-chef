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
  action_list = %w(create add delete remove set reset refresh update configure reconfigure edit none discover apply reapply activate stage new patch)

  oneview_resources = {
    oneview_resource:                   standard_actions,
    oneview_connection_template:        [:update, :reset],
    oneview_datacenter:                 [:add, :remove, :add_if_missing],
    oneview_enclosure:                  [:add, :remove, :refresh, :reconfigure, :patch],
    oneview_enclosure_group:            standard_actions + [:set_script],
    oneview_ethernet_network:           standard_actions + [:reset_connection_template],
    oneview_fabric:                     [:set_reserved_vlan_range],
    oneview_fc_network:                 standard_actions,
    oneview_fcoe_network:               standard_actions,
    oneview_firmware:                   [:add, :remove, :create_custom_spp],
    oneview_interconnect:               [:set_uid_light, :set_power_state, :reset, :reset_port_protection, :update_port],
    oneview_logical_enclosure:          [:create_if_missing, :create, :update_from_group, :reconfigure, :set_script, :delete],
    oneview_logical_interconnect_group: standard_actions,
    oneview_logical_interconnect:       [:none, :add_interconnect, :remove_interconnect, :update_internal_networks, :update_settings,
                                         :update_ethernet_settings, :update_port_monitor, :update_qos_configuration, :update_telemetry_configuration,
                                         :update_snmp_configuration, :update_firmware, :stage_firmware, :activate_firmware, :update_from_group,
                                         :reapply_configuration],
    oneview_logical_switch_group:       standard_actions,
    oneview_logical_switch:             standard_actions + [:refresh],
    oneview_managed_san:                [:set_refresh_state, :set_policy, :set_public_attributes],
    oneview_network_set:                standard_actions,
    oneview_power_device:               [:add, :add_if_missing, :discover, :remove],
    oneview_rack:                       [:add, :remove, :add_if_missing, :add_to_rack, :remove_from_rack],
    oneview_san_manager:                [:add, :add_if_missing, :remove],
    oneview_sas_logical_interconnect_group: standard_actions,
    oneview_server_hardware:            [:add_if_missing, :remove, :refresh, :set_power_state, :update_ilo_firmware],
    oneview_server_hardware_type:       [:edit, :remove],
    oneview_server_profile_template:    standard_actions + [:new_profile],
    oneview_server_profile:             standard_actions,
    oneview_storage_pool:               [:add_if_missing, :remove],
    oneview_storage_system:             [:add, :remove, :edit_credentials, :add_if_missing],
    oneview_switch:                     [:remove, :none],
    oneview_unmanaged_device:           [:add, :remove, :add_if_missing],
    oneview_uplink_set:                 standard_actions,
    oneview_volume:                     standard_actions + [:create_snapshot, :delete_snapshot],
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
