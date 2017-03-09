require_relative './../../../spec_helper'

describe 'oneview_test::uplink_set_load_resource_with_properties' do
  let(:resource_name) { 'uplink_set' }
  include_context 'chef context'
  include_context 'shared context'

  let(:provider) { OneviewCookbook::API200::UplinkSetProvider }

  it 'loads the associated resources' do
    fake_net = OneviewSDK::EthernetNetwork.new(@client, name: 'Ethernet1')
    fake_li = OneviewSDK::LogicalInterconnect.new(@client, name: 'Encl1-LIG')
    fake_fcoe = OneviewSDK::FCoENetwork.new(@client, name: 'FCoE1')
    fake_fc = OneviewSDK::FCNetwork.new(@client, name: 'FC1')

    allow_any_instance_of(provider).to receive(:load_resource).and_call_original
    allow_any_instance_of(provider).to receive(:load_resource).with(:EthernetNetwork, 'Ethernet1').and_return(fake_net)
    allow_any_instance_of(provider).to receive(:load_resource).with(:LogicalInterconnect, 'Encl1-LIG').and_return(fake_li)
    allow_any_instance_of(provider).to receive(:load_resource).with(:Enclosure, { name: 'Encl1', uri: 'Encl1' }, 'uri').and_return('/rest/fake')
    allow_any_instance_of(provider).to receive(:load_resource).with(:FCoENetwork, 'FCoE1').and_return(fake_fcoe)
    allow_any_instance_of(provider).to receive(:load_resource).with(:FCNetwork, 'FC1').and_return(fake_fc)

    expect_any_instance_of(OneviewSDK::UplinkSet).to receive(:add_network).with(fake_net)
    expect_any_instance_of(OneviewSDK::UplinkSet).to receive(:set_logical_interconnect).with(fake_li)
    expect_any_instance_of(OneviewSDK::UplinkSet).to receive(:add_fcoenetwork).with(fake_fcoe)
    expect_any_instance_of(OneviewSDK::UplinkSet).to receive(:add_fcnetwork).with(fake_fc)

    allow_any_instance_of(OneviewSDK::UplinkSet).to receive(:exists?).and_return(false)
    allow_any_instance_of(OneviewSDK::UplinkSet).to receive(:create).and_return(true)
    expect(real_chef_run).to create_oneview_uplink_set('UplinkSet1')
  end
end
