require_relative './../../../spec_helper'

describe 'oneview_test::logical_interconnect_update_firmware' do
  let(:resource_name) { 'logical_interconnect' }
  include_context 'chef context'
  include_context 'shared context'

  let(:klass) { OneviewSDK::LogicalInterconnect }
  let(:provider) { OneviewCookbook::API200::LogicalInterconnectProvider }

  # Mocks the firmware_handler
  before(:each) do
    @firmware_driver = OneviewSDK::FirmwareDriver.new(@client, name: 'Unit SPP', uri: 'rest/firmware/fake')
    allow_any_instance_of(klass).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(klass).to receive(:get_firmware).and_return({})
    allow_any_instance_of(provider).to receive(:load_resource).with(:FirmwareDriver, anything).and_return(@firmware_driver)
  end

  it 'updates the current firmware' do
    expect_any_instance_of(klass).to receive(:firmware_update)
      .with('Update', @firmware_driver, anything).and_return(true)
    expect(real_chef_run).to update_oneview_logical_interconnect_firmware('LogicalInterconnect-update_firmware')
  end

  it 'fails if the resource is not found' do
    expect_any_instance_of(OneviewSDK::LogicalInterconnect).to receive(:retrieve!).and_return(false)
    expect { real_chef_run }.to raise_error(RuntimeError, /not found/)
  end
end
