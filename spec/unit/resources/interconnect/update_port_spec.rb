require_relative './../../../spec_helper'

describe 'oneview_test::interconnect_update_port' do
  let(:resource_name) { 'interconnect' }
  include_context 'chef context'
  include_context 'shared context'

  let(:target_class) { OneviewSDK::API200::Interconnect }
  let(:target_match_method) { [:update_oneview_interconnect_port, 'Interconnect5'] }
  it_behaves_like 'action :update_port'
end

describe 'oneview_test::interconnect_update_port_invalid' do
  let(:resource_name) { 'interconnect' }
  include_context 'chef context'

  let(:target_class) { OneviewSDK::API200::Interconnect }
  it_behaves_like 'action :update_port #update_port with an invalid port'
end
