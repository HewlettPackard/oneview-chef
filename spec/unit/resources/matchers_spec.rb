require_relative './../../spec_helper'

describe 'oneview_test::default' do
  include_context 'chef context'

  it 'converges successfully' do
    chef_run # This should not raise an error
  end

  it 'supports all matchers' do
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

    # oneview_enclosure
    expect(chef_run).to_not add_oneview_enclosure('')
    expect(chef_run).to_not remove_oneview_enclosure('')
    expect(chef_run).to_not refresh_oneview_enclosure('')
    expect(chef_run).to_not reconfigure_oneview_enclosure('')

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

    # oneview_fc_network
    expect(chef_run).to_not create_oneview_fc_network('')
    expect(chef_run).to_not create_oneview_fc_network_if_missing('')
    expect(chef_run).to_not delete_oneview_fc_network('')

    # oneview_fcoe_network
    expect(chef_run).to_not create_oneview_fcoe_network('')
    expect(chef_run).to_not create_oneview_fcoe_network_if_missing('')
    expect(chef_run).to_not delete_oneview_fcoe_network('')

    # oneview_firmware
    expect(chef_run).to_not add_oneview_firmware('')
    expect(chef_run).to_not remove_oneview_firmware('')
    expect(chef_run).to_not create_oneview_firmware_custom_spp('')

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

    # oneview_logical_interconnect_group
    expect(chef_run).to_not create_oneview_logical_interconnect_group('')
    expect(chef_run).to_not create_oneview_logical_interconnect_group_if_missing('')
    expect(chef_run).to_not delete_oneview_logical_interconnect_group('')

    # oneview_logical_switch_group
    expect(chef_run).to_not create_oneview_logical_switch_group('')
    expect(chef_run).to_not create_oneview_logical_switch_group_if_missing('')
    expect(chef_run).to_not delete_oneview_logical_switch_group('')

    # oneview_logical_switch
    expect(chef_run).to_not create_oneview_logical_switch('')
    expect(chef_run).to_not create_oneview_logical_switch_if_missing('')
    expect(chef_run).to_not delete_oneview_logical_switch('')
    expect(chef_run).to_not refresh_oneview_logical_switch('')

    # oneview_managed_san
    expect(chef_run).to_not set_oneview_managed_san_public_attributes('')
    expect(chef_run).to_not set_oneview_managed_san_policy('')
    expect(chef_run).to_not set_refresh_oneview_managed_san_state('')

    # oneview_network_set
    expect(chef_run).to_not create_oneview_network_set('')
    expect(chef_run).to_not create_oneview_network_set_if_missing('')
    expect(chef_run).to_not delete_oneview_network_set('')

    # oneview_power_device
    expect(chef_run).to_not add_oneview_power_device('')
    expect(chef_run).to_not add_oneview_power_device_if_missing('')
    expect(chef_run).to_not discover_oneview_power_device('')
    expect(chef_run).to_not remove_oneview_power_device('')

    # oneview_rack
    expect(chef_run).to_not add_oneview_rack('')
    expect(chef_run).to_not remove_oneview_rack('')
    expect(chef_run).to_not add_oneview_rack_to_rack('')
    expect(chef_run).to_not remove_oneview_rack_from_rack('')

    # oneview_san_manager
    expect(chef_run).to_not add_oneview_san_manager('')
    expect(chef_run).to_not add_oneview_san_manager_if_missing('')
    expect(chef_run).to_not remove_oneview_san_manager('')

    # oneview_server_hardware
    expect(chef_run).to_not add_oneview_server_hardware_if_missing('')
    expect(chef_run).to_not remove_oneview_server_hardware('')
    expect(chef_run).to_not refresh_oneview_server_hardware('')
    expect(chef_run).to_not set_oneview_server_hardware_power_state('')
    expect(chef_run).to_not update_oneview_server_hardware_ilo_firmware('')

    # oneview_server_hardware_type
    expect(chef_run).to_not edit_oneview_server_hardware_type('')
    expect(chef_run).to_not remove_oneview_server_hardware_type('')

    # oneview_storage_pool
    expect(chef_run).to_not add_oneview_storage_pool_if_missing('')
    expect(chef_run).to_not remove_oneview_storage_pool('')

    # oneview_storage_system
    expect(chef_run).to_not add_oneview_storage_system('')
    expect(chef_run).to_not add_oneview_storage_system_if_missing('')
    expect(chef_run).to_not edit_oneview_storage_system_credentials('')
    expect(chef_run).to_not remove_oneview_storage_system('')

    # oneview_switch
    expect(chef_run).to_not remove_oneview_switch('')
    expect(chef_run).to_not none_oneview_switch('')

    # oneview_unmanaged_device
    expect(chef_run).to_not add_oneview_unmanaged_device('')
    expect(chef_run).to_not add_oneview_unmanaged_device_if_missing('')
    expect(chef_run).to_not remove_oneview_unmanaged_device('')

    # oneview_volume
    expect(chef_run).to_not create_oneview_volume('')
    expect(chef_run).to_not create_oneview_volume_if_missing('')
    expect(chef_run).to_not delete_oneview_volume('')
    expect(chef_run).to_not create_oneview_volume_snapshot('')
    expect(chef_run).to_not delete_oneview_volume_snapshot('')

    # oneview_volume_template
    expect(chef_run).to_not create_oneview_volume_template('')
    expect(chef_run).to_not create_oneview_volume_template_if_missing('')
    expect(chef_run).to_not delete_oneview_volume_template('')
  end
end
