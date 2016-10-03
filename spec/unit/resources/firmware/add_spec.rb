require_relative './../../../spec_helper'

describe 'oneview_test::firmware_add' do
  let(:resource_name) { 'firmware' }
  include_context 'chef context'

  it 'adds it when it does not exist' do
    allow(OneviewSDK::FirmwareDriver).to receive(:find_by).and_return([])
    expect(OneviewSDK::FirmwareBundle).to receive(:add).and_return(OneviewSDK::FirmwareDriver.new(client, {}))
    expect(real_chef_run).to add_oneview_firmware('cp027376.exe')
  end

  it 'does nothing when it already exists' do
    allow(OneviewSDK::FirmwareDriver).to receive(:find_by).and_return(
      [
        OneviewSDK::FirmwareDriver.new(client, 'resourceId' => 'cp027376')
      ]
    )
    expect(OneviewSDK::FirmwareBundle).to_not receive(:add)
    expect(real_chef_run).to add_oneview_firmware('cp027376.exe')
  end
end
