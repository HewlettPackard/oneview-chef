require_relative './../../../spec_helper'

describe 'oneview_test_api300_synergy::server_hardware_remove_from_scopes' do
  let(:resource_name) { 'server_hardware' }
  include_context 'chef context'

  let(:target_class) { OneviewSDK::API300::Synergy::ServerHardware }
  let(:scope_class) { OneviewSDK::API300::Synergy::Scope }
  let(:target_match_method) { [:remove_oneview_server_hardware_from_scopes, 'ServerHardware1'] }
  it_behaves_like 'action :remove_from_scopes'
end
