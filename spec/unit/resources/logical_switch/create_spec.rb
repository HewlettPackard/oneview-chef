require_relative './../../../spec_helper'

describe 'oneview_test::logical_switch_create' do
  let(:resource_name) { 'logical_switch' }
  include_context 'chef context'

  it 'creates it when it does not exist' do
    expect_any_instance_of(OneviewSDK::LogicalSwitch).to receive(:exists?).and_return(false)
    expect_any_instance_of(OneviewSDK::LogicalSwitch).to receive(:create).and_return(true)
    expect(real_chef_run).to create_oneview_logical_switch('LogicalSwitch1')
  end

  it 'updates it when it exists but not alike' do
    expect_any_instance_of(OneviewSDK::LogicalSwitch).to receive(:exists?).and_return(true)
    expect_any_instance_of(OneviewSDK::LogicalSwitch).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::LogicalSwitch).to receive(:like?).and_return(false)
    expect_any_instance_of(OneviewSDK::LogicalSwitch).to receive(:update).and_return(true)
    expect(real_chef_run).to create_oneview_logical_switch('LogicalSwitch1')
  end

  it 'does nothing when it exists and is alike' do
    expect_any_instance_of(OneviewSDK::LogicalSwitch).to receive(:exists?).and_return(true)
    expect_any_instance_of(OneviewSDK::LogicalSwitch).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::LogicalSwitch).to receive(:like?).and_return(true)
    expect_any_instance_of(OneviewSDK::LogicalSwitch).to_not receive(:update)
    expect_any_instance_of(OneviewSDK::LogicalSwitch).to_not receive(:create)
    expect(real_chef_run).to create_oneview_logical_switch('LogicalSwitch1')
  end
end
