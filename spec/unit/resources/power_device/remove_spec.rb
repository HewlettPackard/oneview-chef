require_relative './../../../spec_helper'

describe 'oneview_test::power_device_remove' do
  let(:resource_name) { 'power_device' }
  include_context 'chef context'

  let(:target_class) { OneviewSDK::API200::PowerDevice }

  it 'removes it when it exists' do
    allow_any_instance_of(target_class).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(target_class).to receive(:remove).and_return(true)
    expect(real_chef_run).to remove_oneview_power_device('PowerDevice1')
  end

  it 'does nothing when it does not exist' do
    allow_any_instance_of(target_class).to receive(:retrieve!).and_return(false)
    allow(target_class).to receive(:get_ipdu_devices).and_return([])
    expect_any_instance_of(target_class).to_not receive(:remove)
    expect(real_chef_run).to remove_oneview_power_device('PowerDevice1')
  end
end

describe 'oneview_test::power_device_remove_ipdu' do
  let(:resource_name) { 'power_device' }
  include_context 'chef context'

  let(:target_class) { OneviewSDK::API200::PowerDevice }

  it 'removes ipdu when it exists' do
    allow_any_instance_of(target_class).to receive(:retrieve!).and_return(false)
    allow(target_class).to receive(:get_ipdu_devices).and_return(
      [
        target_class.new(client, managedBy: { name: '127.0.0.1' })
      ]
    )
    expect_any_instance_of(target_class).to_not receive(:remove)
    expect(real_chef_run).to remove_oneview_power_device('127.0.0.1')
  end
end
