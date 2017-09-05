require_relative './../../../spec_helper'

describe 'oneview_test::fc_network_create_if_missing' do
  let(:resource_name) { 'fc_network' }
  include_context 'chef context'

  it 'creates it when it does not exist' do
    expect_any_instance_of(OneviewSDK::FCNetwork).to receive(:exists?).and_return(false)
    expect_any_instance_of(OneviewSDK::FCNetwork).to receive(:create).and_return(true)
    expect_any_instance_of(OneviewSDK::ManagedSAN).to receive(:retrieve!).and_return(true)
    expect(real_chef_run).to create_oneview_fc_network_if_missing('FCNetwork2')
  end

  it 'does nothing when it exists' do
    expect_any_instance_of(OneviewSDK::FCNetwork).to receive(:exists?).and_return(true)
    expect_any_instance_of(OneviewSDK::FCNetwork).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::ManagedSAN).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::FCNetwork).to_not receive(:create)
    expect(real_chef_run).to create_oneview_fc_network_if_missing('FCNetwork2')
  end

  it 'fails if the SAN is not found' do
    expect_any_instance_of(OneviewSDK::ManagedSAN).to receive(:retrieve!).and_return(false)
    expect { real_chef_run }.to raise_error(RuntimeError, /'SAN1' not found!/)
  end
end
