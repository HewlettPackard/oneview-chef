require_relative './../../../spec_helper'

describe 'oneview_test_api300_synergy::switch_update_port' do
  let(:resource_name) { 'switch' }
  include_context 'chef context'
  include_context 'shared context'

  let(:target_class) { OneviewSDK::API300::C7000::Switch }
  let(:target_match_method) { [:update_oneview_switch_port, 'Switch1'] }
  it_behaves_like 'action :update_port'
end

describe 'oneview_test_api300_synergy::switch_update_port_invalid' do
  let(:resource_name) { 'switch' }
  include_context 'chef context'

  let(:target_class) { OneviewSDK::API300::C7000::Switch }
  it_behaves_like 'action :update_port #update_port with an invalid port'
end
