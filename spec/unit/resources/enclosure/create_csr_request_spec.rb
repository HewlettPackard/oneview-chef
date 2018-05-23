require_relative './../../../spec_helper'

describe 'oneview_test_api600_synergy::enclosure_create_csr_request' do
  let(:resource_name) { 'enclosure' }
  let(:base_sdk) { OneviewSDK::API600::C7000 }
  include_context 'chef context'
  let(:certificate_request) do
    {
      'type' => 'certificate_type',
      'base64Data' => 'encrypted_data'
    }
  end
  let(:csr_data) do
    {
      'type' => 'CertificateDtoV2',
      'organization' => 'Acme Corp.',
      'organizationalUnit' => 'IT',
      'locality' => 'Townburgh',
      'state' => 'Mississippi',
      'country' => 'US',
      'email' => 'admin@example.com',
      'commonName' => 'fe80::2:0:9:1%eth2'
    }
  end

  it 'creates certificate request' do
    expect_any_instance_of(base_sdk::Enclosure).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(base_sdk::Enclosure).to receive(:create_csr_request).with(csr_data, 1).and_return(true)
    expect_any_instance_of(base_sdk::Enclosure).to receive(:get_csr_request).with(1).and_return(certificate_request)
    allow(File).to receive(:open).and_call_original
    allow(File).to receive(:open).with('/fake/path', 'w').and_return(true)
    expect(real_chef_run).to create_oneview_enclosure_csr_request('Enclosure1')
  end
end
