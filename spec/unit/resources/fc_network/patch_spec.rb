require_relative './../../../spec_helper'

describe 'oneview_test_api300_synergy::fc_network_patch' do
  let(:resource_name) { 'fc_network' }
  include_context 'chef context'

  let(:target_class) { OneviewSDK::API300::Synergy::FCNetwork }
  let(:target_match_method) { [:patch_oneview_fc_network, 'FCNetwork4'] }
  it_behaves_like 'action :patch'
end
