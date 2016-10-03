require_relative './../../../spec_helper'

describe 'oneview_test::power_device_remove' do
  let(:resource_name) { 'power_device' }
  include_context 'chef context'

  it 'removes it when it exists' do
    allow_any_instance_of(OneviewSDK::PowerDevice).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::PowerDevice).to receive(:remove).and_return(true)
    expect(real_chef_run).to remove_oneview_power_device('PowerDevice1')
  end

  it 'does nothing when it does not exist' do
    allow_any_instance_of(OneviewSDK::PowerDevice).to receive(:retrieve!).and_return(false)
    allow(OneviewSDK::PowerDevice).to receive(:get_ipdu_devices).and_return([])
    expect_any_instance_of(OneviewSDK::PowerDevice).to_not receive(:remove)
    expect(real_chef_run).to remove_oneview_power_device('PowerDevice1')
  end
end

describe 'oneview_test::power_device_remove_ipdu' do
  let(:resource_name) { 'power_device' }
  include_context 'chef context'

  it 'removes ipdu when it exists' do
    allow_any_instance_of(OneviewSDK::PowerDevice).to receive(:retrieve!).and_return(false)
    allow(OneviewSDK::PowerDevice).to receive(:get_ipdu_devices).and_return(
      [
        OneviewSDK::PowerDevice.new(client, managedBy: { name: '127.0.0.1' })
      ]
    )
    expect_any_instance_of(OneviewSDK::PowerDevice).to_not receive(:remove)
    expect(real_chef_run).to remove_oneview_power_device('127.0.0.1')
  end
end
