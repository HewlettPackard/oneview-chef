require_relative './../../../spec_helper'

describe 'oneview_test::power_device_discover' do
  let(:resource_name) { 'power_device' }
  include_context 'chef context'

  let(:target_class) { OneviewSDK::API200::PowerDevice }

  it 'discovers an ipdu that does not exists' do
    allow(target_class).to receive(:get_ipdu_devices).and_return([])
    expect(target_class).to receive(:discover)
      .with(
        kind_of(OneviewSDK::Client),
        hostname: '127.0.0.1',
        username: 'username',
        password: 'password'
      )
    expect(real_chef_run).to discover_oneview_power_device('127.0.0.1')
  end

  it 'discovers an ipdu that already exists' do
    allow(target_class).to receive(:get_ipdu_devices).and_return(
      [
        target_class.new(client, managedBy: { name: '127.0.0.1' })
      ]
    )
    expect(target_class).to_not receive(:discover)
    expect(real_chef_run).to discover_oneview_power_device('127.0.0.1')
  end
end
