require_relative './../../../spec_helper'

describe 'oneview_test::firmware_create_custom_spp' do
  let(:resource_name) { 'firmware' }
  include_context 'chef context'

  it 'custom spp already exists' do
    allow_any_instance_of(OneviewSDK::FirmwareDriver).to receive(:exists?).and_return(true)
    expect_any_instance_of(OneviewSDK::FirmwareDriver).to_not receive(:create)
    expect(real_chef_run).to create_oneview_firmware_custom_spp('CustomSPP1')
  end

  it 'does not exists' do
    allow_any_instance_of(OneviewSDK::FirmwareDriver).to receive(:exists?).and_return(false)
    allow_any_instance_of(OneviewSDK::FirmwareDriver).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::FirmwareDriver).to receive(:[]).and_call_original
    allow_any_instance_of(OneviewSDK::FirmwareDriver).to receive(:[]).with('uri').and_return('/rest/firmware-drivers/fw1')
    allow_any_instance_of(OneviewSDK::FirmwareDriver).to receive(:[]).with('hotfixUris')
                                                                     .and_return('/rest/firmware-drivers/fw2', '/rest/firmware-drivers/fw3')
    expect_any_instance_of(OneviewSDK::FirmwareDriver).to receive(:create)
    expect(real_chef_run).to create_oneview_firmware_custom_spp('CustomSPP1')
  end
end

describe 'oneview_test::firmware_create_custom_spp_invalid_spp' do
  let(:resource_name) { 'firmware' }
  include_context 'chef context'

  it 'spp not given' do
    # allow_any_instance_of(OneviewSDK::FirmwareDriver).to receive(:exists?).and_return(false)
    expect { real_chef_run }.to raise_error(RuntimeError, /Unspecified property: 'spp_name'/)
  end
end

describe 'oneview_test::firmware_create_custom_spp_invalid_hotfix' do
  let(:resource_name) { 'firmware' }
  include_context 'chef context'

  it 'hotfix not given' do
    # allow_any_instance_of(OneviewSDK::FirmwareDriver).to receive(:exists?).and_return(false)
    expect { real_chef_run }.to raise_error(RuntimeError, /Unspecified property: 'hotfixes_names'/)
  end
end
