require_relative './../../../spec_helper'

describe 'oneview_test_api300_c7000::ethernet_network_patch' do
  let(:resource_name) { 'ethernet_network' }
  include_context 'chef context'

  it 'performs patch operation' do
    expect_any_instance_of(OneviewSDK::API300::C7000::EthernetNetwork).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::API300::C7000::EthernetNetwork).to receive(:patch).with('test', 'test/', 'TestMessage').and_return(true)
    expect(real_chef_run).to patch_oneview_ethernet_network('EthernetNetwork1')
  end
end
