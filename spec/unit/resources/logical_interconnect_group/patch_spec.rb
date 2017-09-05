require_relative './../../../spec_helper'

describe 'oneview_test_api300_synergy::logical_interconnect_group_patch' do
  let(:resource_name) { 'logical_interconnect_group' }
  include_context 'chef context'

  let(:target_class) { OneviewSDK::API300::Synergy::LogicalInterconnectGroup }
  let(:target_match_method) { [:patch_oneview_logical_interconnect_group, 'LogicalInterconnectGroup1'] }
  it_behaves_like 'action :patch'
end
