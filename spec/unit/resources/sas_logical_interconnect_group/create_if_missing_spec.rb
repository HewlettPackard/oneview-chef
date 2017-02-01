require_relative './../../../spec_helper'

describe 'oneview_test_api300_synergy::sas_logical_interconnect_group_create_if_missing' do
  let(:resource_name) { 'sas_logical_interconnect_group' }
  include_context 'chef context'
  let(:klass) { OneviewSDK::API300::Synergy::SASLogicalInterconnectGroup }

  before :each do
    expect_any_instance_of(klass).to receive(:add_interconnect)
      .with(1, 'Synergy 12Gb SAS Connection Module').and_return(true)
  end

  it 'creates it when it does not exist' do
    expect_any_instance_of(klass).to receive(:exists?).and_return(false)
    expect_any_instance_of(klass).to receive(:create).and_return(true)
    expect(real_chef_run).to create_oneview_sas_logical_interconnect_group_if_missing('SAS LIG 2')
  end

  it 'does nothing when it exists' do
    expect_any_instance_of(klass).to receive(:exists?).and_return(true)
    expect_any_instance_of(klass).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(klass).to_not receive(:create)
    expect(real_chef_run).to create_oneview_sas_logical_interconnect_group_if_missing('SAS LIG 2')
  end
end
