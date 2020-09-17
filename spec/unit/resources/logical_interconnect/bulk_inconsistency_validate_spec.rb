require_relative './../../../spec_helper'

describe 'oneview_test_api2000_c7000::logical_interconnect_bulk_inconsistency_validate' do
  let(:resource_name) { 'logical_interconnect' }
  include_context 'chef context'

  let(:target_class) { OneviewSDK::API2000::Synergy::LogicalInterconnect }
  let(:target_match_method) { [:get_oneview_logical_interconnect_bulk_inconsistency_report, 'LogicalInterconnect1'] }
  it_behaves_like 'action :bulk_inconsistency_validate'
end
