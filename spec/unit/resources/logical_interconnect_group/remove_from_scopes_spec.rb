require_relative './../../../spec_helper'

describe 'oneview_test_api300_synergy::logical_interconnect_group_remove_from_scopes' do
  let(:resource_name) { 'logical_interconnect_group' }
  include_context 'chef context'

  let(:target_class) { OneviewSDK::API300::Synergy::LogicalInterconnectGroup }
  let(:scope_class) { OneviewSDK::API300::Synergy::Scope }
  let(:target_match_method) { [:remove_oneview_logical_interconnect_group_from_scopes, 'LogicalInterconnectGroup1'] }
  it_behaves_like 'action :remove_from_scopes'
end
