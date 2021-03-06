require_relative './../../../spec_helper'

describe 'oneview_test_api300_synergy::switch_replace_scopes' do
  let(:resource_name) { 'switch' }
  include_context 'chef context'

  let(:target_class) { OneviewSDK::API300::C7000::Switch }
  let(:scope_class) { OneviewSDK::API300::C7000::Scope }
  let(:target_match_method) { [:replace_oneview_switch_scopes, 'Switch1'] }
  it_behaves_like 'action :replace_scopes'
end
