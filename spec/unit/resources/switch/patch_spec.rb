require_relative './../../../spec_helper'

describe 'oneview_test_api300_synergy::switch_patch' do
  let(:resource_name) { 'switch' }
  include_context 'chef context'

  let(:target_class) { OneviewSDK::API300::C7000::Switch }
  let(:target_match_method) { [:patch_oneview_switch, 'Switch1'] }
  it_behaves_like 'action :patch'
end
