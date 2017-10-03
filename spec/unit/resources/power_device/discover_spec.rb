require_relative './../../../spec_helper'

describe 'oneview_test::power_device_discover' do
  let(:resource_name) { 'power_device' }
  include_context 'chef context'

  let(:target_class) { OneviewSDK::API200::PowerDevice }

  before do
    expect_any_instance_of(OneviewSDK::API200::ClientCertificate).not_to receive(:import)
    expect(OneviewSDK::API200::WebServerCertificate).not_to receive(:get_certificate)
  end

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

  it 'discovers an ipdu without imported certificate and with auto_import_certificate property false' do
    allow(target_class).to receive(:get_ipdu_devices).and_return([])
    allow(target_class).to receive(:discover) { OneviewSDK::TaskError.raise!('... Unable to retrieve the input certificate ...') }
    expect(target_class).to receive(:discover).once
    expect { real_chef_run }.to raise_error(StandardError, /Unable to retrieve the input certificate/)
  end
end

describe 'oneview_test::power_device_discover_auto_import_certificate' do
  let(:resource_name) { 'power_device' }
  include_context 'chef context'

  let(:base_sdk) { OneviewSDK::API200 }
  let(:target_class) { base_sdk::PowerDevice }

  it 'discovers an ipdu that does not exists and certificate is not imported' do
    allow(target_class).to receive(:get_ipdu_devices).and_return([])
    expect(base_sdk::ClientCertificate).to receive(:new).with(kind_of(OneviewSDK::Client), aliasName: '127.0.0.1').and_call_original
    expect_any_instance_of(base_sdk::ClientCertificate).to receive(:retrieve!).and_return(false)
    expect(base_sdk::WebServerCertificate).to receive(:get_certificate)
      .with(kind_of(OneviewSDK::Client), '127.0.0.1').and_return('base64Data' => 'some_value')
    expect_any_instance_of(base_sdk::ClientCertificate).to receive(:import)
    with_error_seq = [true, false]
    allow(target_class).to receive(:discover) do
      OneviewSDK::TaskError.raise!('... Unable to retrieve the input certificate ...') if with_error_seq.shift
    end
    expect(Chef::Log).to receive(:warn)
    expect(target_class).to receive(:discover)
      .with(
        kind_of(OneviewSDK::Client),
        hostname: '127.0.0.1',
        username: 'username',
        password: 'password'
      )
      .twice
    expect(real_chef_run).to discover_oneview_power_device('127.0.0.1')
  end

  it 'discovers an ipdu that already exists' do
    allow(target_class).to receive(:get_ipdu_devices).and_return(
      [
        target_class.new(client, managedBy: { name: '127.0.0.1' })
      ]
    )
    expect_any_instance_of(OneviewCookbook::API200::PowerDeviceProvider).not_to receive(:import_certificate_for_ipdu)
    expect_any_instance_of(base_sdk::ClientCertificate).not_to receive(:import)
    expect(target_class).to_not receive(:discover)
    expect(real_chef_run).to discover_oneview_power_device('127.0.0.1')
  end

  it 'discovers an ipdu that already imported certificate' do
    allow(target_class).to receive(:get_ipdu_devices).and_return([])
    with_error_seq = [true, false]
    allow(target_class).to receive(:discover) do
      OneviewSDK::TaskError.raise!('... Unable to retrieve the input certificate ...') if with_error_seq.shift
    end
    expect(Chef::Log).to receive(:warn)
    expect_any_instance_of(base_sdk::ClientCertificate).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(base_sdk::ClientCertificate).not_to receive(:import)
    expect(target_class).to receive(:discover).twice
    expect(real_chef_run).to discover_oneview_power_device('127.0.0.1')
  end

  it 'when occurs some error unknown should not import certificate' do
    allow(target_class).to receive(:get_ipdu_devices).and_return([])
    allow(target_class).to receive(:discover) { OneviewSDK::TaskError.raise!('some error') }
    expect(target_class).to receive(:discover).once
    expect { real_chef_run }.to raise_error(StandardError, /some error/)
  end
end
