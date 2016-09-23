require_relative './../../../spec_helper'

describe 'oneview_test::firmware_bundle_add' do
  let(:resource_name) { 'firmware_bundle' }
  include_context 'chef context'

  it 'adds it when it does not exist' do
    allow(OneviewSDK::FirmwareDriver).to receive(:find_by).and_return([])
    expect(OneviewSDK::FirmwareBundle).to receive(:add).and_return(OneviewSDK::FirmwareDriver.new(client, {}))
    expect(real_chef_run).to add_oneview_firmware_bundle('upload cp027376.exe')
  end

  it 'does nothing when it already exists' do
    allow(OneviewSDK::FirmwareDriver).to receive(:find_by).and_return(
      [
        OneviewSDK::FirmwareDriver.new(client, 'fwComponents' => [{ 'fileName' => 'cp027376.exe' }])
      ]
    )
    expect(OneviewSDK::FirmwareBundle).to_not receive(:add)
    expect(real_chef_run).to add_oneview_firmware_bundle('upload cp027376.exe')
  end
end
