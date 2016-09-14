require_relative './../../../spec_helper'

describe 'oneview_test::server_hardware_update_ilo_firmware' do
  let(:resource_name) { 'server_hardware' }
  include_context 'chef context'

  it 'updates ilo firmware' do
    expect_any_instance_of(OneviewSDK::ServerHardware).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::ServerHardware).to receive(:update_ilo_firmware)
    expect(real_chef_run).to update_oneview_server_hardware_ilo_firmware('ServerHardware1')
  end
end
