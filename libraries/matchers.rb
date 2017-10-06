# (c) Copyright 2016-2017 Hewlett Packard Enterprise Development LP
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
  standard_actions = %i[create create_if_missing delete]
  scope_actions = %i[add_to_scopes remove_from_scopes replace_scopes patch]
  # Lists all the possible action verbs
  action_list = %w[create add delete remove set reset refresh update configure reconfigure edit none discover apply reapply activate
                   stage new patch replace change load download upload extract backup allocate collect]

  oneview_resources = {
    oneview_resource:                   standard_actions,
    oneview_connection_template:        %i[update reset],
    oneview_datacenter:                 %i[add remove add_if_missing],
    oneview_drive_enclosure:            %i[hard_reset patch refresh set_uid_light set_power_state],
    oneview_enclosure:                  %i[add remove refresh reconfigure] + scope_actions,
    oneview_enclosure_group:            standard_actions + [:set_script],
    oneview_ethernet_network:           standard_actions + scope_actions + %i[reset_connection_template],
    oneview_event:                      [:create],
    oneview_fabric:                     [:set_reserved_vlan_range],
    oneview_fc_network:                 standard_actions + scope_actions + %i[reset_connection_template],
    oneview_fcoe_network:               standard_actions + scope_actions + %i[reset_connection_template],
    oneview_firmware:                   %i[add remove create_custom_spp],
    oneview_id_pool:                    %i[update allocate_list allocate_count collect_ids],
    oneview_interconnect:               %i[set_uid_light set_power_state reset reset_port_protection update_port],
    oneview_logical_enclosure:          %i[create_if_missing create update_from_group reconfigure set_script delete create_support_dump],
    oneview_logical_interconnect_group: standard_actions + scope_actions,
    oneview_logical_interconnect:       %i[none add_interconnect remove_interconnect update_internal_networks update_settings
                                           update_ethernet_settings update_port_monitor update_qos_configuration update_telemetry_configuration
                                           update_snmp_configuration update_firmware stage_firmware activate_firmware update_from_group
                                           reapply_configuration] + scope_actions,
    oneview_logical_switch_group:       standard_actions + scope_actions,
    oneview_logical_switch:             standard_actions + scope_actions + %i[refresh],
    oneview_managed_san:                %i[refresh set_policy set_public_attributes],
    oneview_network_set:                standard_actions + scope_actions + %i[reset_connection_template],
    oneview_power_device:               %i[add add_if_missing discover remove refresh set_uid_state set_power_state],
    oneview_rack:                       %i[add remove add_if_missing add_to_rack remove_from_rack],
    oneview_san_manager:                %i[add add_if_missing remove],
    oneview_sas_logical_interconnect:   %i[none update_firmware stage_firmware activate_firmware update_from_group reapply_configuration replace_drive_enclosure],
    oneview_sas_interconnect:           %i[reset hard_reset patch refresh set_uid_light set_power_state],
    oneview_sas_logical_interconnect_group: standard_actions,
    oneview_scope:                      standard_actions + [:change_resource_assignments],
    oneview_server_hardware:            %i[add_if_missing remove refresh set_power_state update_ilo_firmware] + scope_actions,
    oneview_server_hardware_type:       %i[edit remove],
    oneview_server_profile_template:    standard_actions,
    oneview_server_profile:             standard_actions + [:update_from_template],
    oneview_storage_pool:               %i[add_if_missing remove update refresh add_for_management remove_from_management],
    oneview_storage_system:             %i[add remove edit_credentials add_if_missing refresh],
    oneview_switch:                     scope_actions + %i[remove none],
    oneview_unmanaged_device:           %i[add remove add_if_missing],
    oneview_uplink_set:                 standard_actions,
    oneview_user:                       standard_actions,
    oneview_volume:                     standard_actions + %i[add_if_missing create_from_snapshot create_snapshot delete_snapshot],
    oneview_volume_template:            standard_actions
  }

  image_streamer_resources = {
    image_streamer_artifact_bundle: %i[create_if_missing update_name delete download upload extract
                                       backup backup_from_file download_backup extract_backup],
    image_streamer_deployment_plan: standard_actions,
    image_streamer_golden_image:    standard_actions + %i[upload_if_missing download download_details_archive],
    image_streamer_os_build_plan:   standard_actions,
    image_streamer_plan_script:     standard_actions
  }

  def define_chefspec_matchers(resource_map, recognized_actions)
    resource_map.each do |resource_type, actions|
      actions.each do |action|
        # Each action should follow <action_clause>_<resource_type>[_<object_complement>] naming standards
        description = action.to_s.split('_')
        # Finds the last action cited in the action description
        action_indexes = recognized_actions.map { |action_word| description.rindex(action_word) }
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

  define_chefspec_matchers(oneview_resources, action_list)
  define_chefspec_matchers(image_streamer_resources, action_list)
end
