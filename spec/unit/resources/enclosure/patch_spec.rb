require_relative './../../../spec_helper'

describe 'oneview_test::enclosure_patch' do
  let(:resource_name) { 'enclosure' }
  include_context 'chef context'

  let(:target_class) { OneviewSDK::API200::Enclosure }
  let(:target_match_method) { [:patch_oneview_enclosure, 'Enclosure1'] }
  it_behaves_like 'action :patch'
end
