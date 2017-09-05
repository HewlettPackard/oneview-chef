require_relative './../../../spec_helper'

describe 'oneview_test::network_set_reset_connection_template' do
  let(:resource_name) { 'network_set' }
  include_context 'chef context'

  let(:default_bandwidth) do
    {
      'bandwidth' => {
        'maximumBandwidth' => 10_000,
        'typicalBandwidth' => 2500
      }
    }
  end

  before do
    allow_any_instance_of(OneviewSDK::NetworkSet).to receive(:[]).and_call_original
    allow_any_instance_of(OneviewSDK::NetworkSet).to receive(:[]).with('connectionTemplateUri').and_return('/rest/fake-template/1')
    allow_any_instance_of(OneviewSDK::NetworkSet).to receive(:retrieve!).and_return(true)
    allow(OneviewSDK::ConnectionTemplate).to receive(:get_default).and_return(default_bandwidth)
    allow_any_instance_of(OneviewSDK::ConnectionTemplate).to receive(:retrieve!).and_return(true)
  end

  it 'updates it when it exists but not alike' do
    allow_any_instance_of(OneviewSDK::ConnectionTemplate).to receive(:like?).and_return(false)
    expect_any_instance_of(OneviewSDK::ConnectionTemplate).to receive(:update).and_return(true)
    expect(real_chef_run).to reset_oneview_network_set_connection_template('NetworkSet5')
  end

  it 'does nothing when it exists and is alike' do
    allow_any_instance_of(OneviewSDK::ConnectionTemplate).to receive(:like?).and_return(true)
    expect_any_instance_of(OneviewSDK::ConnectionTemplate).to_not receive(:update)
    expect(real_chef_run).to reset_oneview_network_set_connection_template('NetworkSet5')
  end

  it 'fails if the resource is not found' do
    expect_any_instance_of(OneviewSDK::NetworkSet).to receive(:retrieve!).and_return(false)
    expect { real_chef_run }.to raise_error(RuntimeError, /not found/)
  end
end
