require_relative './../../../spec_helper'

describe 'oneview_test::network_set_load_resource_with_properties' do
  let(:resource_name) { 'network_set' }
  include_context 'chef context'
  include_context 'shared context'

  it 'loads the associated resources' do
    fake_eth0 = OneviewSDK::EthernetNetwork.new(@client, name: 'FakeEthernetNetwork0', uri: 'rest/fake0')
    fake_eth1 = OneviewSDK::EthernetNetwork.new(@client, name: 'FakeEthernetNetwork1', uri: 'rest/fake1')
    fake_eth2 = OneviewSDK::EthernetNetwork.new(@client, name: 'FakeEthernetNetwork2', uri: 'rest/fake2')
    allow_any_instance_of(OneviewCookbook::API200::NetworkSetProvider).to receive(:load_resource)
      .with(:EthernetNetwork, 'FakeEthernetNetwork0').and_return(fake_eth0)
    allow_any_instance_of(OneviewCookbook::API200::NetworkSetProvider).to receive(:load_resource)
      .with(:EthernetNetwork, 'FakeEthernetNetwork1').and_return(fake_eth1)
    allow_any_instance_of(OneviewCookbook::API200::NetworkSetProvider).to receive(:load_resource)
      .with(:EthernetNetwork, 'FakeEthernetNetwork2').and_return(fake_eth2)

    expect_any_instance_of(OneviewSDK::NetworkSet).to receive(:set_native_network).with(fake_eth0)
    expect_any_instance_of(OneviewSDK::NetworkSet).to receive(:add_ethernet_network).with(fake_eth1)
    expect_any_instance_of(OneviewSDK::NetworkSet).to receive(:add_ethernet_network).with(fake_eth2)

    allow_any_instance_of(OneviewSDK::NetworkSet).to receive(:exists?).and_return(false)
    allow_any_instance_of(OneviewSDK::NetworkSet).to receive(:create).and_return(true)
    expect(real_chef_run).to create_oneview_network_set('NetworkSet4')
  end

  it 'prints a nice error message if the native_set cannot be found' do
    allow_any_instance_of(OneviewSDK::EthernetNetwork).to receive(:retrieve!).and_return(false)
    expect { real_chef_run }.to raise_error(OneviewSDK::NotFound, /FakeEthernetNetwork0/)
  end

  it 'prints a nice error message if a network cannot be found' do
    fake_eth0 = OneviewSDK::EthernetNetwork.new(@client, name: 'FakeEthernetNetwork0', uri: 'rest/fake0')
    allow_any_instance_of(OneviewCookbook::API200::NetworkSetProvider).to receive(:load_resource).and_call_original
    allow_any_instance_of(OneviewCookbook::API200::NetworkSetProvider).to receive(:load_resource)
      .with(:EthernetNetwork, 'FakeEthernetNetwork0').and_return(fake_eth0)
    allow_any_instance_of(OneviewSDK::EthernetNetwork).to receive(:retrieve!).and_return(false)
    expect { real_chef_run }.to raise_error(OneviewSDK::NotFound, /FakeEthernetNetwork1/)
  end
end
