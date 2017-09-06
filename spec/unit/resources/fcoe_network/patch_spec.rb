require_relative './../../../spec_helper'

describe 'oneview_test_api300_synergy::fcoe_network_patch' do
  let(:resource_name) { 'fcoe_network' }
  include_context 'chef context'

  let(:target_class) { OneviewSDK::API300::Synergy::FCoENetwork }
  let(:target_match_method) { [:patch_oneview_fcoe_network, 'FCoENetwork1'] }
  it_behaves_like 'action :patch'
end
