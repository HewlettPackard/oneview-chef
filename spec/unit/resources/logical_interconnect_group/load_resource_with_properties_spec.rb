require_relative './../../../spec_helper'

describe 'oneview_test::logical_interconnect_group_load_resource_with_properties' do
  let(:resource_name) { 'logical_interconnect_group' }
  include_context 'chef context'
  include_context 'shared context'

  it 'creates it loading the properties' do
    allow_any_instance_of(OneviewSDK::LogicalInterconnectGroup).to receive(:exists?).and_return(true)

    # Load the Interconnects
    allow_any_instance_of(OneviewSDK::LogicalInterconnectGroup).to receive(:add_interconnect)
      .with(1, 'TestType1')
    allow_any_instance_of(OneviewSDK::LogicalInterconnectGroup).to receive(:add_interconnect)
      .with(2, 'TestType2')

    # Load the Uplink sets
    ## Ethernet UplinkSet
    allow_any_instance_of(OneviewSDK::EthernetNetwork).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::LIGUplinkSet).to receive(:add_network).with(instance_of(OneviewSDK::EthernetNetwork)).and_return(true)

    allow_any_instance_of(OneviewSDK::LIGUplinkSet).to receive(:add_uplink).with(1, 'X5', nil, 1)
    allow_any_instance_of(OneviewSDK::LIGUplinkSet).to receive(:add_uplink).with(1, 'X6', nil, 1)

    expect_any_instance_of(OneviewSDK::LogicalInterconnectGroup).to receive(:add_uplink_set)

    ## FC UplinkSet
    allow_any_instance_of(OneviewSDK::FCNetwork).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::LIGUplinkSet).to receive(:add_network).with(instance_of(OneviewSDK::FCNetwork)).and_return(true)

    allow_any_instance_of(OneviewSDK::LIGUplinkSet).to receive(:add_uplink).with(2, 'X1', nil, 1)
    allow_any_instance_of(OneviewSDK::LIGUplinkSet).to receive(:add_uplink).with(2, 'X2', nil, 1)

    expect_any_instance_of(OneviewSDK::LogicalInterconnectGroup).to receive(:add_uplink_set)

    allow_any_instance_of(OneviewSDK::LogicalInterconnectGroup).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::LogicalInterconnectGroup).to receive(:like?).and_return(false)
    expect_any_instance_of(OneviewSDK::LogicalInterconnectGroup).to receive(:update).and_return(true)
    expect(real_chef_run).to create_oneview_logical_interconnect_group('LogicalInterconnectGroup4')
  end
end

describe 'oneview_test_api300_synergy::logical_interconnect_group_load_resource_with_synergy_properties' do
  let(:resource_name) { 'logical_interconnect_group' }
  include_context 'chef context'
  include_context 'shared context'

  it 'creates it loading the properties' do
    allow_any_instance_of(OneviewSDK::API300::Synergy::LogicalInterconnectGroup).to receive(:exists?).and_return(true)

    # Load the Interconnects
    allow_any_instance_of(OneviewSDK::API300::Synergy::LogicalInterconnectGroup).to receive(:add_interconnect)
      .with(3, 'TestType1', nil, 1)
    allow_any_instance_of(OneviewSDK::API300::Synergy::LogicalInterconnectGroup).to receive(:add_interconnect)
      .with(6, 'TestType2', nil, 1)
    allow_any_instance_of(OneviewSDK::API300::Synergy::LogicalInterconnectGroup).to receive(:add_interconnect)
      .with(3, 'TestType2', nil, 2)
    allow_any_instance_of(OneviewSDK::API300::Synergy::LogicalInterconnectGroup).to receive(:add_interconnect)
      .with(6, 'TestType1', nil, 2)

    # Load the Uplink sets
    ## Ethernet UplinkSet
    allow_any_instance_of(OneviewSDK::EthernetNetwork).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::LIGUplinkSet).to receive(:add_network)
      .with(instance_of(OneviewSDK::API300::Synergy::EthernetNetwork)).and_return(true)

    allow_any_instance_of(OneviewSDK::LIGUplinkSet).to receive(:add_uplink).with(3, 'Q1', 'TestType1', 1)
    allow_any_instance_of(OneviewSDK::LIGUplinkSet).to receive(:add_uplink).with(6, 'Q1', 'TestType1', 2)

    expect_any_instance_of(OneviewSDK::API300::Synergy::LogicalInterconnectGroup).to receive(:add_uplink_set)

    ## FC UplinkSet
    allow_any_instance_of(OneviewSDK::FCNetwork).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::LIGUplinkSet).to receive(:add_network)
      .with(instance_of(OneviewSDK::API300::Synergy::FCNetwork)).and_return(true)

    allow_any_instance_of(OneviewSDK::LIGUplinkSet).to receive(:add_uplink).with(3, 'Q2', 'TestType1', 1)
    allow_any_instance_of(OneviewSDK::LIGUplinkSet).to receive(:add_uplink).with(6, 'Q2', 'TestType1', 2)

    expect_any_instance_of(OneviewSDK::API300::Synergy::LogicalInterconnectGroup).to receive(:add_uplink_set)

    allow_any_instance_of(OneviewSDK::API300::Synergy::LogicalInterconnectGroup).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::API300::Synergy::LogicalInterconnectGroup).to receive(:like?).and_return(false)
    expect_any_instance_of(OneviewSDK::API300::Synergy::LogicalInterconnectGroup).to receive(:update).and_return(true)
    expect(real_chef_run).to create_oneview_logical_interconnect_group('LogicalInterconnectGroup5')
  end
end
