require_relative './../../../spec_helper'

describe 'oneview_test::ethernet_network_bulk_create' do
  let(:resource_name) { 'ethernet_network' }
  include_context 'chef context'

  it 'bulk creates it' do
    expect_any_instance_of(OneviewSDK::EthernetNetwork).to receive(:bulk_create).and_return(true)
    expect(real_chef_run).to bulk_create_oneview_ethernet_network('BulkEthernetNetwork')
  end
end
