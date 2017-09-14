require_relative './../../../spec_helper'

describe 'oneview_test::power_device_add_if_missing' do
  let(:resource_name) { 'power_device' }
  include_context 'chef context'

  let(:target_class) { OneviewSDK::API200::PowerDevice }

  it 'adds it when it does not exist' do
    expect_any_instance_of(target_class).to receive(:exists?).and_return(false)
    expect_any_instance_of(target_class).to receive(:add).and_return(true)
    expect(real_chef_run).to add_oneview_power_device_if_missing('PowerDevice1')
  end

  it 'does nothing when it exists' do
    expect_any_instance_of(target_class).to receive(:exists?).and_return(true)
    expect_any_instance_of(target_class).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(target_class).to_not receive(:add)
    expect(real_chef_run).to add_oneview_power_device_if_missing('PowerDevice1')
  end
end
