require_relative './../../../spec_helper'

describe 'oneview_test_api1800_c7000::fc_network_delete_bulk' do
  let(:resource_name) { 'fc_network' }
  include_context 'chef context'

  it 'deletes it if it exist' do
    expect_any_instance_of(OneviewSDK::API1800::C7000::FCNetwork).to receive(:delete_bulk).and_return(true)
    expect(real_chef_run).to delete_bulk_oneview_fc_network('FC1')
  end
end
