require_relative './../../../spec_helper'

describe 'oneview_test_api300_synergy::sas_logical_interconnect_update_from_group' do
  let(:resource_name) { 'sas_logical_interconnect' }
  let(:base_sdk) { OneviewSDK::API300::Synergy }
  include_context 'chef context'

  it 'updates the logical interconnect from the logical interconnect group' do
    allow_any_instance_of(base_sdk::SASLogicalInterconnect).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(base_sdk::SASLogicalInterconnect).to receive(:compliance).and_return(true)
    expect(real_chef_run).to update_oneview_sas_logical_interconnect_from_group('SASLogicalInterconnect-update_from_group')
  end
end
