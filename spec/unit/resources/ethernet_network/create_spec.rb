require_relative './../../../spec_helper'

describe 'oneview_test::ethernet_network_create' do
  let(:resource_name) { 'ethernet_network' }
  include_context 'chef context'

  it 'creates it when it does not exist' do
    expect_any_instance_of(OneviewSDK::EthernetNetwork).to receive(:exists?).and_return(false)
    expect_any_instance_of(OneviewSDK::EthernetNetwork).to receive(:create).and_return(true)
    expect(real_chef_run).to create_oneview_ethernet_network('EthernetNetwork1')
  end

  it 'updates it when it exists but not alike' do
    expect_any_instance_of(OneviewSDK::EthernetNetwork).to receive(:exists?).and_return(true)
    expect_any_instance_of(OneviewSDK::EthernetNetwork).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::EthernetNetwork).to receive(:like?).and_return(false)
    expect_any_instance_of(OneviewSDK::EthernetNetwork).to receive(:update).and_return(true)
    expect(real_chef_run).to create_oneview_ethernet_network('EthernetNetwork1')
  end

  it 'does nothing when it exists and is alike' do
    expect_any_instance_of(OneviewSDK::EthernetNetwork).to receive(:exists?).and_return(true)
    expect_any_instance_of(OneviewSDK::EthernetNetwork).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::EthernetNetwork).to receive(:like?).and_return(true)
    expect_any_instance_of(OneviewSDK::EthernetNetwork).to_not receive(:update)
    expect_any_instance_of(OneviewSDK::EthernetNetwork).to_not receive(:create)
    expect(real_chef_run).to create_oneview_ethernet_network('EthernetNetwork1')
  end
end

describe 'oneview_test_api300_synergy::ethernet_network_create' do
  let(:resource_name) { 'ethernet_network' }
  include_context 'chef context'

  it 'creates it when it does not exist' do
    expect_any_instance_of(OneviewSDK::API300::Synergy::EthernetNetwork).to receive(:exists?).and_return(false)
    expect_any_instance_of(OneviewSDK::API300::Synergy::EthernetNetwork).to receive(:create).and_return(true)
    expect(real_chef_run).to create_oneview_ethernet_network('EthNet1')
  end
end
