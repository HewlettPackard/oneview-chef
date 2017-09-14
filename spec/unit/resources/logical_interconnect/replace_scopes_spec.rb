require_relative './../../../spec_helper'

describe 'oneview_test_api300_synergy::logical_interconnect_replace_scopes' do
  let(:resource_name) { 'logical_interconnect' }
  include_context 'chef context'

  let(:target_class) { OneviewSDK::API300::Synergy::LogicalInterconnect }
  let(:scope_class) { OneviewSDK::API300::Synergy::Scope }
  let(:target_match_method) { [:replace_oneview_logical_interconnect_scopes, 'LogicalInterconnect1'] }
  it_behaves_like 'action :replace_scopes'
end
