require_relative './../../../spec_helper'

describe 'oneview_test_api300_synergy::server_hardware_patch' do
  let(:resource_name) { 'server_hardware' }
  include_context 'chef context'

  it 'performs patch operation' do
    expect_any_instance_of(OneviewSDK::API300::Synergy::ServerHardware).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::API300::Synergy::ServerHardware).to receive(:patch).with('test', 'test/', 'TestMessage').and_return(true)
    expect(real_chef_run).to patch_oneview_server_hardware('ServerHardware1')
  end
end
