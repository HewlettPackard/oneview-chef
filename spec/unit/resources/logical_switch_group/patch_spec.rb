require_relative './../../../spec_helper'

describe 'oneview_test_api300_synergy::logical_switch_group_patch' do
  let(:resource_name) { 'logical_switch_group' }
  include_context 'chef context'

  let(:target_class) { OneviewSDK::API300::C7000::LogicalSwitchGroup }
  let(:target_match_method) { [:patch_oneview_logical_switch_group, 'LogicalSwitchGroup1'] }
  it_behaves_like 'action :patch'
end
