require_relative './../../../spec_helper'

describe 'oneview_test::logical_interconnect_group_load_resource_with_properties' do
  let(:resource_name) { 'logical_interconnect_group' }
  include_context 'chef context'

  it 'creates it loading the properties' do
    allow_any_instance_of(OneviewSDK::API200::LogicalInterconnectGroup).to receive(:exists?).and_return(true)

    # Load the Interconnects
    allow_any_instance_of(OneviewSDK::API200::LogicalInterconnectGroup).to receive(:add_interconnect)
      .with(1, 'TestType1')
    allow_any_instance_of(OneviewSDK::API200::LogicalInterconnectGroup).to receive(:add_interconnect)
      .with(2, 'TestType2')

    # Load the Uplink sets
    ## Ethernet UplinkSet
    allow_any_instance_of(OneviewSDK::API200::EthernetNetwork).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::API200::LIGUplinkSet).to receive(:add_network).with(instance_of(OneviewSDK::API200::EthernetNetwork)).and_return(true)

    allow_any_instance_of(OneviewSDK::API200::LIGUplinkSet).to receive(:add_uplink).with(1, 'X5', nil, 1)
    allow_any_instance_of(OneviewSDK::API200::LIGUplinkSet).to receive(:add_uplink).with(1, 'X6', nil, 1)

    expect_any_instance_of(OneviewSDK::API200::LogicalInterconnectGroup).to receive(:add_uplink_set)

    ## FC UplinkSet
    allow_any_instance_of(OneviewSDK::API200::FCNetwork).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::API200::LIGUplinkSet).to receive(:add_network).with(instance_of(OneviewSDK::API200::FCNetwork)).and_return(true)

    allow_any_instance_of(OneviewSDK::API200::LIGUplinkSet).to receive(:add_uplink).with(2, 'X1', nil, 1)
    allow_any_instance_of(OneviewSDK::API200::LIGUplinkSet).to receive(:add_uplink).with(2, 'X2', nil, 1)

    expect_any_instance_of(OneviewSDK::API200::LogicalInterconnectGroup).to receive(:add_uplink_set)

    allow_any_instance_of(OneviewSDK::API200::LogicalInterconnectGroup).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::API200::LogicalInterconnectGroup).to receive(:like?).and_return(false)
    expect_any_instance_of(OneviewSDK::API200::LogicalInterconnectGroup).to receive(:update).and_return(true)
    expect(real_chef_run).to create_oneview_logical_interconnect_group('LogicalInterconnectGroup4')
  end
end

describe 'oneview_test_api300_synergy::logical_interconnect_group_load_resource_with_synergy_properties' do
  let(:resource_name) { 'logical_interconnect_group' }
  include_context 'chef context'

  let(:lig_class) { OneviewSDK::API300::Synergy::LogicalInterconnectGroup }
  let(:ethernet_network_class) { OneviewSDK::API300::Synergy::EthernetNetwork }
  let(:fc_network_class) { OneviewSDK::API300::Synergy::FCNetwork }
  let(:lig_uplink_set_class) { OneviewSDK::API300::Synergy::LIGUplinkSet }

  it 'creates it loading the properties' do
    allow_any_instance_of(lig_class).to receive(:exists?).and_return(true)

    # Load the Interconnects
    allow_any_instance_of(lig_class).to receive(:add_interconnect)
      .with(3, 'TestType1', nil, 1)
    allow_any_instance_of(lig_class).to receive(:add_interconnect)
      .with(6, 'TestType2', nil, 1)
    allow_any_instance_of(lig_class).to receive(:add_interconnect)
      .with(3, 'TestType2', nil, 2)
    allow_any_instance_of(lig_class).to receive(:add_interconnect)
      .with(6, 'TestType1', nil, 2)

    # Load the Uplink sets
    ## Ethernet UplinkSet
    allow_any_instance_of(ethernet_network_class).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(lig_uplink_set_class).to receive(:add_network)
      .with(instance_of(ethernet_network_class)).and_return(true)

    allow_any_instance_of(lig_uplink_set_class).to receive(:add_uplink).with(3, 'Q1', 'TestType1', 1)
    allow_any_instance_of(lig_uplink_set_class).to receive(:add_uplink).with(6, 'Q1', 'TestType1', 2)

    expect_any_instance_of(lig_class).to receive(:add_uplink_set)

    ## FC UplinkSet
    allow_any_instance_of(fc_network_class).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(lig_uplink_set_class).to receive(:add_network)
      .with(instance_of(fc_network_class)).and_return(true)

    allow_any_instance_of(lig_uplink_set_class).to receive(:add_uplink).with(3, 'Q2', 'TestType1', 1)
    allow_any_instance_of(lig_uplink_set_class).to receive(:add_uplink).with(6, 'Q2', 'TestType1', 2)

    expect_any_instance_of(lig_class).to receive(:add_uplink_set)

    allow_any_instance_of(lig_class).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(lig_class).to receive(:like?).and_return(false)
    expect_any_instance_of(lig_class).to receive(:update).and_return(true)
    expect(real_chef_run).to create_oneview_logical_interconnect_group('LogicalInterconnectGroup5')
  end
end
