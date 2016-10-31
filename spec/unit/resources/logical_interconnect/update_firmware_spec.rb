require_relative './../../../spec_helper'

describe 'oneview_test::logical_interconnect_update_firmware' do
  let(:resource_name) { 'logical_interconnect' }
  include_context 'chef context'
  include_context 'shared context'

  # Mocks the firmware_handler
  before(:each) do
    @firmware_driver = OneviewSDK::FirmwareDriver.new(@client, name: 'Unit SPP', uri: 'rest/firmware/fake')
    allow_any_instance_of(OneviewSDK::LogicalInterconnect).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::LogicalInterconnect).to receive(:get_firmware).and_return({})
    allow(OneviewSDK::FirmwareDriver).to receive(:find_by).and_return([@firmware_driver])
  end

  it 'updates the current firmware' do
    expect_any_instance_of(OneviewSDK::LogicalInterconnect).to receive(:firmware_update)
      .with('Update', @firmware_driver, anything).and_return(true)
    expect(real_chef_run).to update_oneview_logical_interconnect_firmware('LogicalInterconnect-update_firmware')
  end
end
