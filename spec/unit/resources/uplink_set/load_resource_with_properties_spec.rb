require_relative './../../../spec_helper'

describe 'oneview_test::uplink_set_load_resource_with_properties' do
  let(:resource_name) { 'uplink_set' }
  include_context 'chef context'
  include_context 'shared context'

  it 'loads the associated resources' do
    fake_net = OneviewSDK::EthernetNetwork.new(@client, name: 'Ethernet1')
    allow(OneviewSDK::EthernetNetwork).to receive(:find_by).with(anything, name: 'Ethernet1').and_return([fake_net])
    fake_li = OneviewSDK::LogicalInterconnect.new(@client, name: 'Encl1-LIG')
    allow(OneviewSDK::LogicalInterconnect).to receive(:find_by).with(anything, name: 'Encl1-LIG').and_return([fake_li])

    expect_any_instance_of(OneviewSDK::UplinkSet).to receive(:add_network).with(fake_net)
    expect_any_instance_of(OneviewSDK::UplinkSet).to receive(:set_logical_interconnect).with(fake_li)

    allow_any_instance_of(OneviewSDK::UplinkSet).to receive(:exists?).and_return(false)
    allow_any_instance_of(OneviewSDK::UplinkSet).to receive(:create).and_return(true)
    expect(real_chef_run).to create_oneview_uplink_set('UplinkSet1')
  end
end
