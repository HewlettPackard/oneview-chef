require_relative './../../../spec_helper'

describe 'oneview_test_api300_synergy::logical_interconnect_add_to_scopes' do
  let(:resource_name) { 'logical_interconnect' }
  include_context 'chef context'

  let(:target_class) { OneviewSDK::API300::Synergy::LogicalInterconnect }
  let(:scope_class) { OneviewSDK::API300::Synergy::Scope }
  let(:target_match_method) { [:add_oneview_logical_interconnect_to_scopes, 'LogicalInterconnect1'] }
  it_behaves_like 'action :add_to_scopes'
end
