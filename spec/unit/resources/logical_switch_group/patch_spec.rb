require_relative './../../../spec_helper'

describe 'oneview_test::logical_switch_group_patch' do
  include_context 'chef context'
  let(:resource_name) { 'logical_switch_group' }

  it 'performs patch operation' do
    expect_any_instance_of(OneviewSDK::API300::C7000::LogicalSwitchGroup).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::API300::C7000::LogicalSwitchGroup).to receive(:patch).with('test', 'test/', 'TestMessage').and_return(true)
    expect(real_chef_run).to patch_oneview_logical_switch_group('LogicalSwitchGroup4')
  end
end
