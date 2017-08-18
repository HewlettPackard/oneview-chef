require_relative './../../../spec_helper'

describe 'oneview_test::server_hardware_refresh' do
  let(:resource_name) { 'server_hardware' }
  include_context 'chef context'

  it 'refresh server hardware already triggered' do
    expect_any_instance_of(OneviewSDK::ServerHardware).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::ServerHardware).to receive(:[]).with('refreshState')
                                                                     .and_return('RefreshPending')
    allow_any_instance_of(OneviewSDK::ServerHardware).to receive(:[]).with('name')
                                                                     .and_return('ServerHardware1')
    expect_any_instance_of(OneviewSDK::ServerHardware).to_not receive(:set_refresh_state)
    expect(real_chef_run).to refresh_oneview_server_hardware('ServerHardware1')
  end

  it 'refresh server hardware with default options' do
    expect_any_instance_of(OneviewSDK::ServerHardware).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::ServerHardware).to receive(:[]).with('refreshState')
                                                                     .and_return('NotRefreshing')
    allow_any_instance_of(OneviewSDK::ServerHardware).to receive(:[]).with('name')
                                                                     .and_return('ServerHardware1')
    expect_any_instance_of(OneviewSDK::ServerHardware).to receive(:set_refresh_state).and_return(true)
    expect(real_chef_run).to refresh_oneview_server_hardware('ServerHardware1')
  end
end
