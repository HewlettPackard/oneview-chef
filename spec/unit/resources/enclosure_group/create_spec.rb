require_relative './../../../spec_helper'

describe 'oneview_test::enclosure_group_create' do
  let(:resource_name) { 'enclosure_group' }
  include_context 'chef context'

  it 'accepts a logical_interconnect_groups parameter' do
    expect_any_instance_of(OneviewSDK::EnclosureGroup).to receive(:add_logical_interconnect_group).twice.and_return(true)
    expect_any_instance_of(OneviewSDK::EnclosureGroup).to receive(:exists?).and_return(false)
    expect_any_instance_of(OneviewSDK::EnclosureGroup).to receive(:create).and_return(true)
    expect(real_chef_run).to create_oneview_enclosure_group('EnclosureGroup1')
  end
end

describe 'oneview_test_api300_synergy::enclosure_group_create' do
  let(:resource_name) { 'enclosure_group' }
  include_context 'chef context'
  let(:klass) { OneviewSDK::API300::Synergy::EnclosureGroup }

  it 'accepts a logical_interconnect_groups parameter' do
    expect_any_instance_of(klass).to receive(:add_logical_interconnect_group)
      .with(anything, nil).and_return(true)
    expect_any_instance_of(klass).to receive(:add_logical_interconnect_group)
      .with(anything, 1).and_return(true)
    expect_any_instance_of(klass).to receive(:exists?).and_return(false)
    expect_any_instance_of(klass).to receive(:create).and_return(true)
    expect(real_chef_run).to create_oneview_enclosure_group('EnclosureGroup1')
  end

  it 'looks for a sas lig if a regular one is not found' do
    lig_class = OneviewSDK::API300::Synergy::LogicalInterconnectGroup
    sas_lig_class = OneviewSDK::API300::Synergy::SASLogicalInterconnectGroup
    expect_any_instance_of(klass).to receive(:add_logical_interconnect_group)
      .with(instance_of(lig_class), nil).and_raise(OneviewSDK::NotFound)
    expect_any_instance_of(klass).to receive(:add_logical_interconnect_group)
      .with(instance_of(sas_lig_class), nil).and_return(true)
    expect_any_instance_of(klass).to receive(:add_logical_interconnect_group)
      .with(anything, 1).and_return(true)
    expect_any_instance_of(klass).to receive(:exists?).and_return(false)
    expect_any_instance_of(klass).to receive(:create).and_return(true)
    expect(real_chef_run).to create_oneview_enclosure_group('EnclosureGroup1')
  end
end
