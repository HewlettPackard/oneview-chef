require_relative './../../../spec_helper'

describe 'oneview_test_api600_c7000::server_certificate_import_certificate' do
  let(:resource_name) { 'server_certificate' }
  include_context 'chef context'
  expected_output = {
    'aliasName' => '172.18.13.11',
    'remoteIp' => '172.18.13.11',
    'type' => 'CertificateInfoV2',
    'certificateDetails' =>
     [{
       'type' => 'CertificateDetailV2',
       'base64Data' => 'some certificate data'
     }]
  }

  it 'adds it when it does not exist' do
    expect_any_instance_of(OneviewSDK::API600::C7000::ServerCertificate).to receive(:get_certificate).and_return(expected_output)
    expect_any_instance_of(OneviewSDK::API600::C7000::ServerCertificate).to receive(:import).and_return(true)
    expect(real_chef_run).to import_certificate_oneview_server_certificate('172.18.13.11')
  end
end
