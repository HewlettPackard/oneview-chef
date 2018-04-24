require_relative './../../../spec_helper'

describe 'oneview_test_api600_synergy::server_hardware_add_multiple_servers' do
  let(:resource_name) { 'server_hardware' }
  let(:base_sdk) { OneviewSDK::API600::C7000 }
  include_context 'chef context'

  it 'adds it when it does not exist' do
    expect_any_instance_of(base_sdk::ServerHardware).to receive(:add_multiple_servers).and_return(true)
    expect(real_chef_run).to add_multiple_servers_oneview_server_hardware('ServerHardware1')
  end
end
