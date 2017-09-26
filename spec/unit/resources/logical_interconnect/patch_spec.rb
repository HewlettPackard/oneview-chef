require_relative './../../../spec_helper'

describe 'oneview_test_api300_synergy::logical_interconnect_patch' do
  let(:resource_name) { 'logical_interconnect' }
  include_context 'chef context'

  let(:target_class) { OneviewSDK::API300::Synergy::LogicalInterconnect }
  let(:target_match_method) { [:patch_oneview_logical_interconnect, 'LogicalInterconnect1'] }
  it_behaves_like 'action :patch'
end
