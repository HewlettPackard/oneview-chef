require_relative './../../../spec_helper'

describe 'oneview_test::server_hardware_set_power_state' do
  let(:resource_name) { 'server_hardware' }
  include_context 'chef context'

  it 'sets the Server hardware power state to a valid value' do
    allow_any_instance_of(OneviewSDK::ServerHardware).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::ServerHardware).to receive(:[]).with('powerState').and_return('off')
    allow_any_instance_of(OneviewSDK::ServerHardware).to receive(:[]).with('name').and_return('ServerHardware1')
    expect_any_instance_of(OneviewSDK::ServerHardware).to receive(:power_on)
    expect(real_chef_run).to set_oneview_server_hardware_power_state('ServerHardware1')
  end

  it 'server hardware power state is alike' do
    allow_any_instance_of(OneviewSDK::ServerHardware).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::ServerHardware).to receive(:[]).with('powerState').and_return('on')
    allow_any_instance_of(OneviewSDK::ServerHardware).to receive(:[]).with('name').and_return('ServerHardware1')
    expect_any_instance_of(OneviewSDK::ServerHardware).to_not receive(:power_on)
    expect(real_chef_run).to set_oneview_server_hardware_power_state('ServerHardware1')
  end
end
