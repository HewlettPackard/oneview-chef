require_relative './../../../spec_helper'

describe 'oneview_test_api600_synergy::enclosure_import_ertificate' do
  let(:resource_name) { 'enclosure' }
  include_context 'chef context'

  it 'imports a signed certificate' do
    expect_any_instance_of(base_sdk::Enclosure).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(base_sdk::Enclosure).to receive(:import_certificate).and_return(true)
    expect(real_chef_run).to create_csr_request_oneview_enclosure('Enclosure1')
  end
end
