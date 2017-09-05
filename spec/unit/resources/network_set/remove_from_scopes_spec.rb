require_relative './../../../spec_helper'

describe 'oneview_test_api300_synergy::network_set_remove_from_scopes' do
  let(:resource_name) { 'network_set' }
  include_context 'chef context'

  let(:target_class) { OneviewSDK::API300::Synergy::NetworkSet }
  let(:scope_class) { OneviewSDK::API300::Synergy::Scope }
  let(:target_match_method) { [:remove_oneview_network_set_from_scopes, 'NetworkSet1'] }
  it_behaves_like 'action :remove_from_scopes'
end
