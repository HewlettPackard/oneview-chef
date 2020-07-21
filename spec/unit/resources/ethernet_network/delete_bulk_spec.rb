require_relative './../../../spec_helper'

describe 'oneview_test_api1800_c7000::ethernet_network_bulk_delete' do
  let(:resource_name) { 'ethernet_network' }
  include_context 'chef context'
  let(:target_class) { OneviewSDK::API1800::C7000::EthernetNetwork }

  it 'deletes it if it exist' do
    expect_any_instance_of(target_class).to receive(:delete_bulk).and_return(true)
    expect(real_chef_run).to bulk_delete_oneview_ethernet_network('Eth1')
  end
end
