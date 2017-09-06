require_relative './../../../spec_helper'

describe 'oneview_test::fc_network_reset_connection_template' do
  let(:resource_name) { 'fc_network' }
  include_context 'chef context'

  let(:target_class) { OneviewSDK::API200::FCNetwork }
  let(:connection_template_class) { OneviewSDK::API200::ConnectionTemplate }
  let(:target_match_method) { [:reset_oneview_fc_network_connection_template, 'FCNetwork4'] }
  it_behaves_like 'action :reset_connection_template'
end
