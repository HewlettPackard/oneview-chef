require_relative './../../../spec_helper'

describe 'oneview_test_api600_c7000::server_certificate_update_certificate' do
  let(:resource_name) { 'server_certificate' }
  include_context 'chef context'

  it 'adds it when it does not exist' do
    expect_any_instance_of(OneviewSDK::API600::C7000::ServerCertificate).to receive(:update_certificate).and_return(true)
    expect(real_chef_run).to update_certificate_oneview_server_certificate('172.18.13.11')
  end
end
