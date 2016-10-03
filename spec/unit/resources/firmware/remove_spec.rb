require_relative './../../../spec_helper'

describe 'oneview_test::firmware_remove' do
  let(:resource_name) { 'firmware' }
  include_context 'chef context'

  it 'removes it when it exists' do
    allow(OneviewSDK::FirmwareDriver).to receive(:find_by).and_return(
      [
        OneviewSDK::FirmwareDriver.new(client, 'resourceId' => 'cp027376')
      ]
    )
    allow_any_instance_of(OneviewSDK::FirmwareDriver).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::FirmwareDriver).to receive(:remove).and_return(true)
    expect(real_chef_run).to remove_oneview_firmware('cp027376.exe')
  end

  it 'does nothing when it does not exist' do
    allow(OneviewSDK::FirmwareDriver).to receive(:find_by).and_return(
      [
        OneviewSDK::FirmwareDriver.new(client, 'resourceId' => 'cp027')
      ]
    )
    allow_any_instance_of(OneviewSDK::FirmwareDriver).to receive(:retrieve!).and_return(false)
    expect_any_instance_of(OneviewSDK::FirmwareDriver).to_not receive(:remove)
    expect(real_chef_run).to remove_oneview_firmware('cp027376.exe')
  end
end
