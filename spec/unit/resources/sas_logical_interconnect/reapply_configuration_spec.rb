require_relative './../../../spec_helper'

describe 'oneview_test_api300_synergy::sas_logical_interconnect_reapply_configuration' do
  let(:resource_name) { 'sas_logical_interconnect' }
  let(:base_sdk) { OneviewSDK::API300::Synergy }
  include_context 'chef context'

  it 'reapplies the configuration in all teh associated interconnects' do
    allow_any_instance_of(base_sdk::SASLogicalInterconnect).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(base_sdk::SASLogicalInterconnect).to receive(:configuration).and_return(true)
    expect(real_chef_run).to reapply_oneview_sas_logical_interconnect_configuration('SASLogicalInterconnect-reapply_configuration')
  end
end
