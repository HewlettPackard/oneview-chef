require_relative './../../../spec_helper'

describe 'oneview_test_api300_synergy::ethernet_network_patch' do
  let(:resource_name) { 'ethernet_network' }
  include_context 'chef context'

  let(:target_class) { OneviewSDK::API300::Synergy::EthernetNetwork }
  let(:target_match_method) { [:patch_oneview_ethernet_network, 'EthernetNetwork1'] }
  it_behaves_like 'action :patch'
end
