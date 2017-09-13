require_relative './../../../spec_helper'

describe 'oneview_test::power_device_set_power_state_on' do
  let(:resource_name) { 'power_device' }
  include_context 'chef context'

  let(:target_class) { OneviewSDK::API200::PowerDevice }

  it 'sets the power state to On when power state original value is Off' do
    expect_any_instance_of(target_class).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(target_class).to receive(:get_power_state).and_return('Off')
    expect_any_instance_of(target_class).to receive(:set_power_state).with('On')
    expect(real_chef_run).to set_oneview_power_device_power_state('PowerDevicePowerStateOn')
  end

  it 'do nothing when power state original value is On' do
    expect_any_instance_of(target_class).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(target_class).to receive(:get_power_state).and_return('On')
    expect_any_instance_of(target_class).not_to receive(:set_power_state)
    expect(real_chef_run).to set_oneview_power_device_power_state('PowerDevicePowerStateOn')
  end

  it 'raise error when power device not found' do
    expect_any_instance_of(target_class).to receive(:retrieve!).and_return(false)
    allow(target_class).to receive(:get_ipdu_devices).and_return([])
    expect { real_chef_run }.to raise_error(RuntimeError, /not found/)
  end
end

describe 'oneview_test::power_device_set_power_state_off' do
  let(:resource_name) { 'power_device' }
  include_context 'chef context'

  let(:target_class) { OneviewSDK::API200::PowerDevice }

  it 'sets the power state to Off when power state original value is On' do
    expect_any_instance_of(target_class).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(target_class).to receive(:get_power_state).and_return('On')
    expect_any_instance_of(target_class).to receive(:set_power_state).with('Off')
    expect(real_chef_run).to set_oneview_power_device_power_state('PowerDevicePowerStateOff')
  end

  it 'do nothing when power state original value is Off' do
    expect_any_instance_of(target_class).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(target_class).to receive(:get_power_state).and_return('Off')
    expect_any_instance_of(target_class).not_to receive(:set_power_state)
    expect(real_chef_run).to set_oneview_power_device_power_state('PowerDevicePowerStateOff')
  end

  it 'raise error when power device not found' do
    expect_any_instance_of(target_class).to receive(:retrieve!).and_return(false)
    allow(target_class).to receive(:get_ipdu_devices).and_return([])
    expect { real_chef_run }.to raise_error(RuntimeError, /not found/)
  end
end
