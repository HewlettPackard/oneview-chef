require_relative './../../../spec_helper'

describe 'oneview_test_api300_synergy::network_set_patch' do
  let(:resource_name) { 'network_set' }
  include_context 'chef context'

  let(:target_class) { OneviewSDK::API300::Synergy::NetworkSet }
  let(:target_match_method) { [:patch_oneview_network_set, 'NetworkSet1'] }
  it_behaves_like 'action :patch'
end
