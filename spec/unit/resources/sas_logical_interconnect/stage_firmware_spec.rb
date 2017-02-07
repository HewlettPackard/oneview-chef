require_relative './../../../spec_helper'

describe 'oneview_test_api300_synergy::sas_logical_interconnect_stage_firmware' do
  let(:resource_name) { 'sas_logical_interconnect' }
  let(:base_sdk) { OneviewSDK::API300::Synergy }
  include_context 'chef context'
  include_context 'shared context'

  # Mocks the firmware_handler
  before(:each) do
    @firmware_driver = base_sdk::FirmwareDriver.new(@client, name: 'Unit SPP', uri: 'rest/firmware/fake')
    allow_any_instance_of(base_sdk::SASLogicalInterconnect).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(base_sdk::SASLogicalInterconnect).to receive(:get_firmware).and_return({})
    allow(base_sdk::FirmwareDriver).to receive(:find_by).and_return([@firmware_driver])
  end

  it 'stages the current firmware' do
    expect_any_instance_of(base_sdk::SASLogicalInterconnect).to receive(:firmware_update)
      .with('Stage', @firmware_driver, anything).and_return(true)
    expect(real_chef_run).to stage_oneview_sas_logical_interconnect_firmware('SASLogicalInterconnect-stage_firmware')
  end
end
