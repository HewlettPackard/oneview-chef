require_relative './../../../spec_helper'

describe 'oneview_test::logical_interconnect_reapply_configuration' do
  let(:resource_name) { 'logical_interconnect' }
  include_context 'chef context'

  let(:target_class) { OneviewSDK::API200::LogicalInterconnect }
  let(:target_match_method) { [:reapply_oneview_logical_interconnect_configuration, 'LogicalInterconnect-reapply_configuration'] }
  it_behaves_like 'action :reapply_configuration'
end
