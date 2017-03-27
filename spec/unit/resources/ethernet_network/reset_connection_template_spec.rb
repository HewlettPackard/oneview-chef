require_relative './../../../spec_helper'

describe 'oneview_test::ethernet_network_reset_connection_template' do
  let(:resource_name) { 'ethernet_network' }
  include_context 'chef context'

  let(:default_bandwidth) do
    {
      'bandwidth' => {
        'maximumBandwidth' => 10_000,
        'typicalBandwidth' => 2500
      }
    }
  end

  it 'updates it when it exists but not alike' do
    allow_any_instance_of(OneviewSDK::EthernetNetwork).to receive(:retrieve!).and_return(true)
    allow(OneviewSDK::ConnectionTemplate).to receive(:get_default).and_return(default_bandwidth)
    allow_any_instance_of(OneviewSDK::ConnectionTemplate).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::ConnectionTemplate).to receive(:like?).and_return(false)
    expect_any_instance_of(OneviewSDK::ConnectionTemplate).to receive(:update).and_return(true)
    expect(real_chef_run).to reset_oneview_ethernet_network_connection_template('EthernetNetwork4')
  end

  it 'does nothing when it exists and is alike' do
    allow_any_instance_of(OneviewSDK::EthernetNetwork).to receive(:retrieve!).and_return(true)
    allow(OneviewSDK::ConnectionTemplate).to receive(:get_default).and_return(default_bandwidth)
    allow_any_instance_of(OneviewSDK::ConnectionTemplate).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::ConnectionTemplate).to receive(:like?).and_return(true)
    expect_any_instance_of(OneviewSDK::ConnectionTemplate).to_not receive(:update)
    expect(real_chef_run).to reset_oneview_ethernet_network_connection_template('EthernetNetwork4')
  end

  it 'fails if the resource is not found' do
    expect_any_instance_of(OneviewSDK::EthernetNetwork).to receive(:retrieve!).and_return(false)
    expect { real_chef_run }.to raise_error(RuntimeError, /not found/)
  end
end
