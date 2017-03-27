require_relative './../../../spec_helper'

describe 'oneview_test::logical_switch_refresh' do
  let(:resource_name) { 'logical_switch' }
  include_context 'chef context'

  it 'creates it when it does not exist' do
    expect_any_instance_of(OneviewSDK::LogicalSwitch).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::LogicalSwitch).to receive(:refresh_state).and_return(true)
    expect(real_chef_run).to refresh_oneview_logical_switch('LogicalSwitch4')
  end

  it 'raises error when it does not exist' do
    expect_any_instance_of(OneviewSDK::LogicalSwitch).to receive(:retrieve!).and_return(false)
    expect_any_instance_of(OneviewSDK::LogicalSwitch).to_not receive(:refresh_state)
    expect { real_chef_run }.to raise_error(RuntimeError, /not found/)
  end
end
