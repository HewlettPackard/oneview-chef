require_relative './../../../spec_helper'

describe 'oneview_test::logical_switch_group_create_if_missing' do
  let(:resource_name) { 'logical_switch_group' }
  include_context 'chef context'

  before(:each) do
    allow(OneviewSDK::Switch).to receive(:get_type).with(anything, 'Cisco Nexus 50xx')
                                                   .and_return('uri' => 'rest/fake/switch-uri')
  end

  it 'creates it when it does not exist' do
    expect_any_instance_of(OneviewSDK::LogicalSwitchGroup).to receive(:exists?).and_return(false)
    expect_any_instance_of(OneviewSDK::LogicalSwitchGroup).to receive(:create).and_return(true)
    expect(real_chef_run).to create_oneview_logical_switch_group_if_missing('LogicalSwitchGroup2')
  end

  it 'does nothing when it exists' do
    expect_any_instance_of(OneviewSDK::LogicalSwitchGroup).to receive(:exists?).and_return(true)
    expect_any_instance_of(OneviewSDK::LogicalSwitchGroup).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::LogicalSwitchGroup).to_not receive(:create)
    expect(real_chef_run).to create_oneview_logical_switch_group_if_missing('LogicalSwitchGroup2')
  end
end
