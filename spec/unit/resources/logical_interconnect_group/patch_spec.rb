require_relative './../../../spec_helper'

describe 'oneview_test_api300_c7000::logical_interconnect_group_patch' do
  let(:resource_name) { 'logical_interconnect_group' }
  include_context 'chef context'

  it 'performs patch operation' do
    expect_any_instance_of(OneviewSDK::API300::C7000::LogicalInterconnectGroup).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::API300::C7000::LogicalInterconnectGroup).to receive(:patch)
      .with('test', 'test/', 'TestMessage')
      .and_return(true)
    expect(real_chef_run).to patch_oneview_logical_interconnect_group('LogicalInterconnectGroup1')
  end
end
