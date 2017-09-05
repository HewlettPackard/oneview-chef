require_relative './../../../spec_helper'

describe 'oneview_test_api300_synergy::fc_network_add_to_scopes' do
  let(:resource_name) { 'fc_network' }
  include_context 'chef context'

  let(:target_class) { OneviewSDK::API300::Synergy::FCNetwork }
  let(:scope_class) { OneviewSDK::API300::Synergy::Scope }
  let(:target_match_method) { [:add_oneview_fc_network_to_scopes, 'FCNetwork1'] }
  it_behaves_like 'action :add_to_scopes'
end
