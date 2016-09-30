require_relative './../../../spec_helper'

describe 'oneview_test::logical_switch_delete' do
  let(:resource_name) { 'logical_switch' }
  include_context 'chef context'

  it 'deletes it when it exists' do
    expect_any_instance_of(OneviewSDK::LogicalSwitch).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::LogicalSwitch).to receive(:delete).and_return(true)
    expect(real_chef_run).to delete_oneview_logical_switch('LogicalSwitch3')
  end

  it 'does nothing when it does not exist' do
    expect_any_instance_of(OneviewSDK::LogicalSwitch).to receive(:retrieve!).and_return(false)
    expect_any_instance_of(OneviewSDK::LogicalSwitch).to_not receive(:delete)
    expect(real_chef_run).to delete_oneview_logical_switch('LogicalSwitch3')
  end
end
