require_relative './../../../spec_helper'

describe 'oneview_test::ethernet_network_reset_connection_template' do
  let(:resource_name) { 'ethernet_network' }
  include_context 'chef context'

  let(:target_class) { OneviewSDK::API200::EthernetNetwork }
  let(:connection_template_class) { OneviewSDK::API200::ConnectionTemplate }
  let(:target_match_method) { [:reset_oneview_ethernet_network_connection_template, 'EthernetNetwork4'] }
  it_behaves_like 'action :reset_connection_template'
end
