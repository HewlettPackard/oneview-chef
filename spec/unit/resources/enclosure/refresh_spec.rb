require_relative './../../../spec_helper'

describe 'oneview_test::enclosure_refresh' do
  let(:resource_name) { 'enclosure' }
  include_context 'chef context'

  let(:target_class) { OneviewSDK::Enclosure }
  let(:target_match_method) { [:refresh_oneview_enclosure, 'Enclosure1'] }
  it_behaves_like 'action :refresh #set_refresh_state'
end
