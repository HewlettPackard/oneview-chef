require_relative './../../../spec_helper'

describe 'oneview_test_api300_synergy::server_hardware_patch' do
  let(:resource_name) { 'server_hardware' }
  include_context 'chef context'

  let(:target_class) { OneviewSDK::API300::Synergy::ServerHardware }
  let(:target_match_method) { [:patch_oneview_server_hardware, 'ServerHardware1'] }
  it_behaves_like 'action :patch'
end
