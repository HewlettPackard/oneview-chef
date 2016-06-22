require_relative './../../../spec_helper'

describe 'oneview_test::enclosure_group_create' do
  let(:resource_name) { 'enclosure_group' }
  include_context 'chef context'

  it 'accepts a logical_interconnect_group parameter' do
    expect_any_instance_of(OneviewSDK::EnclosureGroup).to receive(:add_logical_interconnect_group).and_return(true)
    expect_any_instance_of(OneviewSDK::EnclosureGroup).to receive(:exists?).and_return(false)
    expect_any_instance_of(OneviewSDK::EnclosureGroup).to receive(:create).and_return(true)
    expect(real_chef_run).to create_oneview_enclosure_group('EnclosureGroup1')
  end
end
