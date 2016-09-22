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

    allow_any_instance_of(OneviewSDK::LIGUplinkSet).to receive(:add_uplink).with(1, 'X5')
    allow_any_instance_of(OneviewSDK::LIGUplinkSet).to receive(:add_uplink).with(1, 'X6')

    expect_any_instance_of(OneviewSDK::LogicalInterconnectGroup).to receive(:add_uplink_set)

    ## FC UplinkSet
    allow_any_instance_of(OneviewSDK::FCNetwork).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::LIGUplinkSet).to receive(:add_network).with(instance_of(OneviewSDK::FCNetwork)).and_return(true)

    allow_any_instance_of(OneviewSDK::LIGUplinkSet).to receive(:add_uplink).with(2, 'X1')
    allow_any_instance_of(OneviewSDK::LIGUplinkSet).to receive(:add_uplink).with(2, 'X2')

    expect_any_instance_of(OneviewSDK::LogicalInterconnectGroup).to receive(:add_uplink_set)

    allow_any_instance_of(OneviewSDK::LogicalInterconnectGroup).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::LogicalInterconnectGroup).to receive(:like?).and_return(false)
    expect_any_instance_of(OneviewSDK::LogicalInterconnectGroup).to receive(:update).and_return(true)
    expect(real_chef_run).to create_oneview_logical_interconnect_group('LogicalInterconnectGroup4')
  end
end
