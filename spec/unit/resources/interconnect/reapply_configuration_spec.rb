require_relative './../../../spec_helper'

describe 'oneview_test_api500_synergy::interconnect_reapply_configuration' do
  let(:resource_name) { 'interconnect' }
  include_context 'chef context'

  let(:target_class) { OneviewSDK::API500::Synergy::Interconnect }
  let(:target_match_method) { [:reapply_oneview_interconnect_configuration, 'Interconnect-reapply_configuration'] }
  it_behaves_like 'action :reapply_configuration'
end
