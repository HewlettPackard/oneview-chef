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
    expect(chef_run).to_not bulk_create_oneview_ethernet_network('')
    expect(chef_run).to_not create_oneview_ethernet_network_if_missing('')
    expect(chef_run).to_not delete_oneview_ethernet_network('')

    # oneview_network_set
    expect(chef_run).to_not create_oneview_network_set('')
    expect(chef_run).to_not create_oneview_network_set_if_missing('')
    expect(chef_run).to_not delete_oneview_network_set('')

    # oneview_fc_network
    expect(chef_run).to_not create_oneview_fc_network('')
    expect(chef_run).to_not create_oneview_fc_network_if_missing('')
    expect(chef_run).to_not delete_oneview_fc_network('')

    # oneview_fcoe_network
    expect(chef_run).to_not create_oneview_fcoe_network('')
    expect(chef_run).to_not create_oneview_fcoe_network_if_missing('')
    expect(chef_run).to_not delete_oneview_fcoe_network('')

    # oneview_logical_enclosure
    expect(chef_run).to_not update_oneview_logical_enclosure_from_group('')
    expect(chef_run).to_not reconfigure_oneview_logical_enclosure('')
    expect(chef_run).to_not set_oneview_logical_enclosure_script('')

    # oneview_logical_interconnect_group
    expect(chef_run).to_not create_oneview_logical_interconnect_group('')
    expect(chef_run).to_not create_oneview_logical_interconnect_group_if_missing('')
    expect(chef_run).to_not delete_oneview_logical_interconnect_group('')

    # oneview_storage_pool
    expect(chef_run).to_not add_oneview_storage_pool('')
    expect(chef_run).to_not remove_oneview_storage_pool('')

    # oneview_storage_system
    expect(chef_run).to_not add_oneview_storage_system('')
    expect(chef_run).to_not remove_oneview_storage_system('')

    # oneview_volume
    expect(chef_run).to_not create_oneview_volume('')
    expect(chef_run).to_not create_oneview_volume_if_missing('')
    expect(chef_run).to_not delete_oneview_volume('')

    # oneview_volume_template
    expect(chef_run).to_not create_oneview_volume_template('')
    expect(chef_run).to_not create_oneview_volume_template_if_missing('')
    expect(chef_run).to_not delete_oneview_volume_template('')
  end
end
