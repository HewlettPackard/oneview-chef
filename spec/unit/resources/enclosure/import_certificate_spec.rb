require_relative './../../../spec_helper'

describe 'oneview_test_api600_synergy::enclosure_import_certificate' do
  let(:resource_name) { 'enclosure' }
  let(:base_sdk) { OneviewSDK::API600::C7000 }
  include_context 'chef context'
  let(:bay_number) { 1 }
  let(:csr_data) do
    {
      'type' => 'CertificateDataV2',
      'base64Data' => nil
    }
  end

  it 'imports a signed certificate' do
    allow(File).to receive(:open).and_call_original
    allow(File).to receive(:open).with('csr_data_file.txt').and_return(true)
    expect_any_instance_of(base_sdk::Enclosure).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(base_sdk::Enclosure).to receive(:import_certificate).with(csr_data, bay_number).and_return(true)
    expect(real_chef_run).to import_oneview_enclosure_certificate('Enclosure1')
  end
end
