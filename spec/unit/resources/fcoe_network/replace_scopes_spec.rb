require_relative './../../../spec_helper'

describe 'oneview_test_api300_synergy::fcoe_network_replace_scopes' do
  let(:resource_name) { 'fcoe_network' }
  include_context 'chef context'

  let(:target_class) { OneviewSDK::API300::Synergy::FCoENetwork }
  let(:scope_class) { OneviewSDK::API300::Synergy::Scope }
  let(:target_match_method) { [:replace_oneview_fcoe_network_scopes, 'FCoENetwork1'] }
  it_behaves_like 'action :replace_scopes'
end
