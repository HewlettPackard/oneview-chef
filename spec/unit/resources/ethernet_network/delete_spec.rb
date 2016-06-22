require_relative './../../../spec_helper'

describe 'oneview_test::ethernet_network_delete' do
  let(:resource_name) { 'ethernet_network' }
  include_context 'chef context'

  it 'deletes it when it exists' do
    expect_any_instance_of(OneviewSDK::EthernetNetwork).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::EthernetNetwork).to receive(:delete).and_return(true)
    expect(real_chef_run).to delete_oneview_ethernet_network('EthernetNetwork3')
  end

  it 'does nothing when it does not exist' do
    expect_any_instance_of(OneviewSDK::EthernetNetwork).to receive(:retrieve!).and_return(false)
    expect_any_instance_of(OneviewSDK::EthernetNetwork).to_not receive(:delete)
    expect(real_chef_run).to delete_oneview_ethernet_network('EthernetNetwork3')
  end
end
