require_relative './../../../spec_helper'

describe 'oneview_test::server_hardware_type_edit' do
  let(:resource_name) { 'server_hardware_type' }
  include_context 'chef context'

  it 'raise error when it does not exists' do
    allow_any_instance_of(OneviewSDK::ServerHardwareType).to receive(:exists?).and_return(false)
    expect { real_chef_run }.to raise_error(RuntimeError, /ResourceNotFound:.+ServerHardwareType1/)
  end

  it 'updates it when it exists but not alike' do
    allow_any_instance_of(OneviewSDK::ServerHardwareType).to receive(:exists?).and_return(true)
    allow_any_instance_of(OneviewSDK::ServerHardwareType).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::ServerHardwareType).to receive(:like?).and_return(false)
    expect_any_instance_of(OneviewSDK::ServerHardwareType).to receive(:update)
    expect(real_chef_run).to edit_oneview_server_hardware_type('ServerHardwareType1')
  end

  it 'does nothing when it exists and is alike' do
    allow_any_instance_of(OneviewSDK::ServerHardwareType).to receive(:exists?).and_return(true)
    allow_any_instance_of(OneviewSDK::ServerHardwareType).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::ServerHardwareType).to receive(:like?).and_return(true)
    expect_any_instance_of(OneviewSDK::ServerHardwareType).to_not receive(:update)
    expect(real_chef_run).to edit_oneview_server_hardware_type('ServerHardwareType1')
  end
end
