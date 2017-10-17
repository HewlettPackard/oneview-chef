require_relative './../../../spec_helper'

describe 'oneview_test_api300_synergy::sas_logical_interconnect_reapply_configuration' do
  let(:resource_name) { 'sas_logical_interconnect' }
  include_context 'chef context'

  let(:target_class) { OneviewSDK::API300::Synergy::SASLogicalInterconnect }
  let(:target_match_method) { [:reapply_oneview_sas_logical_interconnect_configuration, 'SASLogicalInterconnect-reapply_configuration'] }
  it_behaves_like 'action :reapply_configuration'
end
