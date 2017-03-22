require_relative './../../../spec_helper'

describe 'oneview_test::logical_interconnect_activate_firmware' do
  let(:resource_name) { 'logical_interconnect' }
  include_context 'chef context'
  include_context 'shared context'

  # Mocks the firmware_handler
  before(:each) do
    allow_any_instance_of(OneviewSDK::LogicalInterconnect).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::LogicalInterconnect).to receive(:get_firmware).and_return({})
    allow_any_instance_of(OneviewSDK::FirmwareDriver).to receive(:retrieve!).and_return(true)
  end

  it 'activates the current firmware' do
    expect_any_instance_of(OneviewSDK::LogicalInterconnect).to receive(:firmware_update)
      .with('Activate', instance_of(OneviewSDK::FirmwareDriver), anything).and_return(true)
    expect(real_chef_run).to activate_oneview_logical_interconnect_firmware('LogicalInterconnect-activate_firmware')
  end

  it 'fails if the resource is not found' do
    expect_any_instance_of(OneviewSDK::LogicalInterconnect).to receive(:retrieve!).and_return(false)
    expect { real_chef_run }.to raise_error(RuntimeError, /not found/)
  end
end
