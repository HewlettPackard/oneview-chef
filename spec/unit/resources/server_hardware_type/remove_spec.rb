require_relative './../../../spec_helper'

describe 'oneview_test::server_hardware_type_remove' do
  let(:resource_name) { 'server_hardware_type' }
  include_context 'chef context'

  it 'removes it when it exists' do
    expect_any_instance_of(OneviewSDK::ServerHardwareType).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::ServerHardwareType).to receive(:remove).and_return(true)
    expect(real_chef_run).to remove_oneview_server_hardware_type('ServerHardwareType1')
  end

  it 'does nothing when it does not exist' do
    expect_any_instance_of(OneviewSDK::ServerHardwareType).to receive(:retrieve!).and_return(false)
    expect_any_instance_of(OneviewSDK::ServerHardwareType).to_not receive(:remove)
    expect(real_chef_run).to remove_oneview_server_hardware_type('ServerHardwareType1')
  end
end
