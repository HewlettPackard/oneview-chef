require_relative './../../../spec_helper'

describe 'oneview_test::fcoe_network_reset_connection_template' do
  let(:resource_name) { 'fcoe_network' }
  include_context 'chef context'

  let(:target_class) { OneviewSDK::API200::FCoENetwork }
  let(:connection_template_class) { OneviewSDK::API200::ConnectionTemplate }
  let(:target_match_method) { [:reset_oneview_fcoe_network_connection_template, 'FCoENetwork4'] }
  it_behaves_like 'action :reset_connection_template'
end
