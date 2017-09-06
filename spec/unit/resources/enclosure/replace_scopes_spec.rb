require_relative './../../../spec_helper'

describe 'oneview_test_api300_synergy::enclosure_replace_scopes' do
  let(:resource_name) { 'enclosure' }
  include_context 'chef context'

  let(:target_class) { OneviewSDK::API300::Synergy::Enclosure }
  let(:scope_class) { OneviewSDK::API300::Synergy::Scope }
  let(:target_match_method) { [:replace_oneview_enclosure_scopes, 'Enclosure1'] }
  it_behaves_like 'action :replace_scopes'
end
