require_relative './../../../spec_helper'
require 'FileUtils'

describe 'oneview_test_api600_synergy::enclosure_import_ertificate' do
  let(:resource_name) { 'enclosure' }
  let(:base_sdk) { OneviewSDK::API600::C7000 }
  include_context 'chef context'
  let(:csr_data) do
    {
      'type' => 'CertificateDataV2',
      'base64Data' => 'encrypted_data'
    }
  end

  it 'imports a signed certificate' do
    expect_any_instance_of(base_sdk::Enclosure).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(base_sdk::Enclosure).to receive(:import_certificate).with(csr_data).and_return(true)
    expect(real_chef_run).to import_oneview_enclosure_certificate('Enclosure1')
  end
end
