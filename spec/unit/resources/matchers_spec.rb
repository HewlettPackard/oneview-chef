require_relative './../../spec_helper'

describe 'oneview_test::default' do
  include_context 'chef context'

  it 'converges successfully' do
    chef_run # This should not raise an error
  end

  it 'supports all oneview matchers' do
    # oneview_resource
    expect(chef_run).to_not create_oneview_resource('')
    expect(chef_run).to_not delete_oneview_resource('')
    expect(chef_run).to_not create_oneview_resource_if_missing('')

    # oneview_connection_template
    expect(chef_run).to_not update_oneview_connection_template('')
    expect(chef_run).to_not reset_oneview_connection_template('')

    # oneview_datacenter
    expect(chef_run).to_not add_oneview_datacenter('')
    expect(chef_run).to_not remove_oneview_datacenter('')
    expect(chef_run).to_not add_oneview_datacenter_if_missing('')

    # oneview_drive_enclosure
    expect(chef_run).to_not hard_reset_oneview_drive_enclosure('')
    expect(chef_run).to_not patch_oneview_drive_enclosure('')
    expect(chef_run).to_not refresh_oneview_drive_enclosure('')
    expect(chef_run).to_not set_oneview_drive_enclosure_power_state('')
    expect(chef_run).to_not set_oneview_drive_enclosure_uid_light('')

    # oneview_enclosure
    expect(chef_run).to_not add_oneview_enclosure('')
    expect(chef_run).to_not remove_oneview_enclosure('')
    expect(chef_run).to_not refresh_oneview_enclosure('')
    expect(chef_run).to_not reconfigure_oneview_enclosure('')
    expect(chef_run).to_not patch_oneview_enclosure('')
    expect(chef_run).to_not add_oneview_enclosure_to_scopes('')
    expect(chef_run).to_not remove_oneview_enclosure_from_scopes('')
    expect(chef_run).to_not replace_oneview_enclosure_scopes('')

    # oneview_enclosure_group
    expect(chef_run).to_not create_oneview_enclosure_group('')
    expect(chef_run).to_not create_oneview_enclosure_group_if_missing('')
    expect(chef_run).to_not delete_oneview_enclosure_group('')
    expect(chef_run).to_not set_oneview_enclosure_group_script('')

    # oneview_ethernet_network
    expect(chef_run).to_not create_oneview_ethernet_network('')
    expect(chef_run).to_not create_oneview_ethernet_network_if_missing('')
    expect(chef_run).to_not reset_oneview_ethernet_network_connection_template('')
    expect(chef_run).to_not delete_oneview_ethernet_network('')
    expect(chef_run).to_not add_oneview_ethernet_network_to_scopes('')
    expect(chef_run).to_not remove_oneview_ethernet_network_from_scopes('')
    expect(chef_run).to_not replace_oneview_ethernet_network_scopes('')
    expect(chef_run).to_not patch_oneview_ethernet_network('')

    # oneview_event
    expect(chef_run).to_not create_oneview_event('')

    # oneview_fabric
    expect(chef_run).to_not set_oneview_fabric_reserved_vlan_range('')

    # oneview_fc_network
    expect(chef_run).to_not create_oneview_fc_network('')
    expect(chef_run).to_not create_oneview_fc_network_if_missing('')
    expect(chef_run).to_not delete_oneview_fc_network('')
    expect(chef_run).to_not add_oneview_fc_network_to_scopes('')
    expect(chef_run).to_not remove_oneview_fc_network_from_scopes('')
    expect(chef_run).to_not replace_oneview_fc_network_scopes('')
    expect(chef_run).to_not patch_oneview_fc_network('')
    expect(chef_run).to_not reset_oneview_fc_network_connection_template('')

    # oneview_fcoe_network
    expect(chef_run).to_not create_oneview_fcoe_network('')
    expect(chef_run).to_not create_oneview_fcoe_network_if_missing('')
    expect(chef_run).to_not delete_oneview_fcoe_network('')
    expect(chef_run).to_not add_oneview_fcoe_network_to_scopes('')
    expect(chef_run).to_not remove_oneview_fcoe_network_from_scopes('')
    expect(chef_run).to_not replace_oneview_fcoe_network_scopes('')
    expect(chef_run).to_not patch_oneview_fcoe_network('')

    # oneview_firmware
    expect(chef_run).to_not add_oneview_firmware('')
    expect(chef_run).to_not remove_oneview_firmware('')
    expect(chef_run).to_not create_oneview_firmware_custom_spp('')

    # oneview_id_pool
    expect(chef_run).to_not update_oneview_id_pool('')
    expect(chef_run).to_not allocate_oneview_id_pool_list('')
    expect(chef_run).to_not allocate_oneview_id_pool_count('')
    expect(chef_run).to_not collect_oneview_id_pool_ids('')

    # oneview_interconnect
    expect(chef_run).to_not set_oneview_interconnect_uid_light('')
    expect(chef_run).to_not set_oneview_interconnect_power_state('')
    expect(chef_run).to_not reset_oneview_interconnect_port_protection('')
    expect(chef_run).to_not reset_oneview_interconnect('')
    expect(chef_run).to_not update_oneview_interconnect_port('')

    # oneview_logical_enclosure
    expect(chef_run).to_not update_oneview_logical_enclosure_from_group('')
    expect(chef_run).to_not reconfigure_oneview_logical_enclosure('')
    expect(chef_run).to_not set_oneview_logical_enclosure_script('')
    expect(chef_run).to_not create_oneview_logical_enclosure('')
    expect(chef_run).to_not create_oneview_logical_enclosure_if_missing('')
    expect(chef_run).to_not delete_oneview_logical_enclosure('')
    expect(chef_run).to_not create_oneview_logical_enclosure_support_dump('')

    # oneview_logical_interconnect
    expect(chef_run).to_not add_oneview_logical_interconnect_interconnect('')
    expect(chef_run).to_not remove_oneview_logical_interconnect_interconnect('')
    expect(chef_run).to_not reapply_oneview_logical_interconnect_configuration('')
    expect(chef_run).to_not update_oneview_logical_interconnect_from_group('')
    expect(chef_run).to_not activate_oneview_logical_interconnect_firmware('')
    expect(chef_run).to_not stage_oneview_logical_interconnect_firmware('')
    expect(chef_run).to_not update_oneview_logical_interconnect_ethernet_settings('')
    expect(chef_run).to_not update_oneview_logical_interconnect_firmware('')
    expect(chef_run).to_not update_oneview_logical_interconnect_internal_networks('')
    expect(chef_run).to_not update_oneview_logical_interconnect_port_monitor('')
    expect(chef_run).to_not update_oneview_logical_interconnect_qos_configuration('')
    expect(chef_run).to_not update_oneview_logical_interconnect_settings('')
    expect(chef_run).to_not update_oneview_logical_interconnect_snmp_configuration('')
    expect(chef_run).to_not update_oneview_logical_interconnect_telemetry_configuration('')
    expect(chef_run).to_not add_oneview_logical_interconnect_to_scopes('')
    expect(chef_run).to_not remove_oneview_logical_interconnect_from_scopes('')
    expect(chef_run).to_not replace_oneview_logical_interconnect_scopes('')
    expect(chef_run).to_not patch_oneview_logical_interconnect('')

    # oneview_logical_interconnect_group
    expect(chef_run).to_not create_oneview_logical_interconnect_group('')
    expect(chef_run).to_not create_oneview_logical_interconnect_group_if_missing('')
    expect(chef_run).to_not delete_oneview_logical_interconnect_group('')
    expect(chef_run).to_not add_oneview_logical_interconnect_group_to_scopes('')
    expect(chef_run).to_not remove_oneview_logical_interconnect_group_from_scopes('')
    expect(chef_run).to_not replace_oneview_logical_interconnect_group_scopes('')
    expect(chef_run).to_not patch_oneview_logical_interconnect_group('')

    # oneview_logical_switch_group
    expect(chef_run).to_not create_oneview_logical_switch_group('')
    expect(chef_run).to_not create_oneview_logical_switch_group_if_missing('')
    expect(chef_run).to_not delete_oneview_logical_switch_group('')
    expect(chef_run).to_not add_oneview_logical_switch_group_to_scopes('')
    expect(chef_run).to_not remove_oneview_logical_switch_group_from_scopes('')
    expect(chef_run).to_not replace_oneview_logical_switch_group_scopes('')
    expect(chef_run).to_not patch_oneview_logical_switch_group('')

    # oneview_logical_switch
    expect(chef_run).to_not create_oneview_logical_switch('')
    expect(chef_run).to_not create_oneview_logical_switch_if_missing('')
    expect(chef_run).to_not delete_oneview_logical_switch('')
    expect(chef_run).to_not refresh_oneview_logical_switch('')
    expect(chef_run).to_not add_oneview_logical_switch_to_scopes('')
    expect(chef_run).to_not remove_oneview_logical_switch_from_scopes('')
    expect(chef_run).to_not replace_oneview_logical_switch_scopes('')
    expect(chef_run).to_not patch_oneview_logical_switch('')

    # oneview_managed_san
    expect(chef_run).to_not set_oneview_managed_san_public_attributes('')
    expect(chef_run).to_not set_oneview_managed_san_policy('')
    expect(chef_run).to_not refresh_oneview_managed_san('')

    # oneview_network_set
    expect(chef_run).to_not create_oneview_network_set('')
    expect(chef_run).to_not create_oneview_network_set_if_missing('')
    expect(chef_run).to_not delete_oneview_network_set('')
    expect(chef_run).to_not add_oneview_network_set_to_scopes('')
    expect(chef_run).to_not remove_oneview_network_set_from_scopes('')
    expect(chef_run).to_not replace_oneview_network_set_scopes('')
    expect(chef_run).to_not patch_oneview_network_set('')
    expect(chef_run).to_not reset_oneview_network_set_connection_template('')

    # oneview_power_device
    expect(chef_run).to_not add_oneview_power_device('')
    expect(chef_run).to_not add_oneview_power_device_if_missing('')
    expect(chef_run).to_not discover_oneview_power_device('')
    expect(chef_run).to_not remove_oneview_power_device('')
    expect(chef_run).to_not refresh_oneview_power_device('')
    expect(chef_run).to_not set_oneview_power_device_power_state('')
    expect(chef_run).to_not set_oneview_power_device_uid_state('')

    # oneview_rack
    expect(chef_run).to_not add_oneview_rack('')
    expect(chef_run).to_not remove_oneview_rack('')
    expect(chef_run).to_not add_oneview_rack_to_rack('')
    expect(chef_run).to_not remove_oneview_rack_from_rack('')

    # oneview_san_manager
    expect(chef_run).to_not add_oneview_san_manager('')
    expect(chef_run).to_not add_oneview_san_manager_if_missing('')
    expect(chef_run).to_not remove_oneview_san_manager('')

    # oneview_sas_logical_interconnect
    expect(chef_run).to_not reapply_oneview_sas_logical_interconnect_configuration('')
    expect(chef_run).to_not update_oneview_sas_logical_interconnect_from_group('')
    expect(chef_run).to_not activate_oneview_sas_logical_interconnect_firmware('')
    expect(chef_run).to_not stage_oneview_sas_logical_interconnect_firmware('')
    expect(chef_run).to_not update_oneview_sas_logical_interconnect_firmware('')
    expect(chef_run).to_not replace_oneview_sas_logical_interconnect_drive_enclosure('')

    # oneview_sas_interconnect
    expect(chef_run).to_not hard_reset_oneview_sas_interconnect('')
    expect(chef_run).to_not patch_oneview_sas_interconnect('')
    expect(chef_run).to_not refresh_oneview_sas_interconnect('')
    expect(chef_run).to_not reset_oneview_sas_interconnect('')
    expect(chef_run).to_not set_oneview_sas_interconnect_power_state('')
    expect(chef_run).to_not set_oneview_sas_interconnect_uid_light('')

    # oneview_sas_logical_interconnect_group
    expect(chef_run).to_not create_oneview_sas_logical_interconnect_group('')
    expect(chef_run).to_not create_oneview_sas_logical_interconnect_group_if_missing('')
    expect(chef_run).to_not delete_oneview_sas_logical_interconnect_group('')

    # oneview_scope
    expect(chef_run).to_not create_oneview_scope('')
    expect(chef_run).to_not create_oneview_scope_if_missing('')
    expect(chef_run).to_not delete_oneview_scope('')
    expect(chef_run).to_not change_oneview_scope_resource_assignments('')

    # oneview_server_hardware
    expect(chef_run).to_not add_oneview_server_hardware_if_missing('')
    expect(chef_run).to_not remove_oneview_server_hardware('')
    expect(chef_run).to_not refresh_oneview_server_hardware('')
    expect(chef_run).to_not set_oneview_server_hardware_power_state('')
    expect(chef_run).to_not update_oneview_server_hardware_ilo_firmware('')
    expect(chef_run).to_not patch_oneview_server_hardware('')
    expect(chef_run).to_not add_oneview_server_hardware_to_scopes('')
    expect(chef_run).to_not remove_oneview_server_hardware_from_scopes('')
    expect(chef_run).to_not replace_oneview_server_hardware_scopes('')

    # oneview_server_hardware_type
    expect(chef_run).to_not edit_oneview_server_hardware_type('')
    expect(chef_run).to_not remove_oneview_server_hardware_type('')

    # oneview_server_profile
    expect(chef_run).to_not create_oneview_server_profile('')
    expect(chef_run).to_not create_oneview_server_profile_if_missing('')
    expect(chef_run).to_not delete_oneview_server_profile('')
    expect(chef_run).to_not update_oneview_server_profile_from_template('')

    # oneview_server_profile_template
    expect(chef_run).to_not create_oneview_server_profile_template('')
    expect(chef_run).to_not create_oneview_server_profile_template_if_missing('')
    expect(chef_run).to_not delete_oneview_server_profile_template('')

    # oneview_storage_pool
    expect(chef_run).to_not add_oneview_storage_pool_if_missing('')
    expect(chef_run).to_not remove_oneview_storage_pool('')
    expect(chef_run).to_not add_oneview_storage_pool_for_management('')
    expect(chef_run).to_not remove_oneview_storage_pool_from_management('')
    expect(chef_run).to_not refresh_oneview_storage_pool('')
    expect(chef_run).to_not update_oneview_storage_pool('')

    # oneview_storage_system
    expect(chef_run).to_not add_oneview_storage_system('')
    expect(chef_run).to_not add_oneview_storage_system_if_missing('')
    expect(chef_run).to_not edit_oneview_storage_system_credentials('')
    expect(chef_run).to_not refresh_oneview_storage_system('')
    expect(chef_run).to_not remove_oneview_storage_system('')

    # oneview_switch
    expect(chef_run).to_not remove_oneview_switch('')
    expect(chef_run).to_not none_oneview_switch('')
    expect(chef_run).to_not add_oneview_switch_to_scopes('')
    expect(chef_run).to_not remove_oneview_switch_from_scopes('')
    expect(chef_run).to_not replace_oneview_switch_scopes('')
    expect(chef_run).to_not patch_oneview_switch('')

    # oneview_unmanaged_device
    expect(chef_run).to_not add_oneview_unmanaged_device('')
    expect(chef_run).to_not add_oneview_unmanaged_device_if_missing('')
    expect(chef_run).to_not remove_oneview_unmanaged_device('')

    # oneview_uplink_set
    expect(chef_run).to_not create_oneview_uplink_set('')
    expect(chef_run).to_not create_oneview_uplink_set_if_missing('')
    expect(chef_run).to_not delete_oneview_uplink_set('')

    # oneview_user
    expect(chef_run).to_not create_oneview_user('')
    expect(chef_run).to_not create_oneview_user_if_missing('')
    expect(chef_run).to_not delete_oneview_user('')

    # oneview_volume
    expect(chef_run).to_not create_oneview_volume('')
    expect(chef_run).to_not create_oneview_volume_if_missing('')
    expect(chef_run).to_not delete_oneview_volume('')
    expect(chef_run).to_not create_oneview_volume_snapshot('')
    expect(chef_run).to_not delete_oneview_volume_snapshot('')
    expect(chef_run).to_not add_oneview_volume_if_missing('')
    expect(chef_run).to_not create_oneview_volume_from_snapshot('')

    # oneview_volume_template
    expect(chef_run).to_not create_oneview_volume_template('')
    expect(chef_run).to_not create_oneview_volume_template_if_missing('')
    expect(chef_run).to_not delete_oneview_volume_template('')
  end

  it 'supports all image streamer matchers' do
    # image_streamer_deployment_plan
    expect(chef_run).to_not create_image_streamer_deployment_plan('')
    expect(chef_run).to_not delete_image_streamer_deployment_plan('')
    expect(chef_run).to_not create_image_streamer_deployment_plan_if_missing('')

    # image_streamer_golden_image
    expect(chef_run).to_not create_image_streamer_golden_image('')
    expect(chef_run).to_not delete_image_streamer_golden_image('')
    expect(chef_run).to_not create_image_streamer_golden_image_if_missing('')
    expect(chef_run).to_not upload_image_streamer_golden_image_if_missing('')
    expect(chef_run).to_not download_image_streamer_golden_image('')
    expect(chef_run).to_not download_image_streamer_golden_image_details_archive('')

    # image_streamer_os_build_plan
    expect(chef_run).to_not create_image_streamer_os_build_plan('')
    expect(chef_run).to_not delete_image_streamer_os_build_plan('')
    expect(chef_run).to_not create_image_streamer_os_build_plan_if_missing('')

    # image_streamer_plan_script
    expect(chef_run).to_not create_image_streamer_plan_script('')
    expect(chef_run).to_not delete_image_streamer_plan_script('')
    expect(chef_run).to_not create_image_streamer_plan_script_if_missing('')
  end
end
