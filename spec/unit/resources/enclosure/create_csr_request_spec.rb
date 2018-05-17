require_relative './../../../spec_helper'

describe 'oneview_test_api600_synergy::enclosure_create_csr_request' do
  let(:resource_name) { 'enclosure' }
  include_context 'chef context'

  it 'creates it when does not exist' do
    expect_any_instance_of(base_sdk::Enclosure).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(base_sdk::Enclosure).to receive(:create_csr_request).and_return(true)
    expect_any_instance_of(base_sdk::Enclosure).to receive(:get_csr_request).and_return(true)
    expect(real_chef_run).to create_csr_request_oneview_enclosure('Enclosure1')
  end
end
