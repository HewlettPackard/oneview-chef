require_relative './../../../spec_helper'

describe 'oneview_test::fcoe_network_create' do
  let(:resource_name) { 'fcoe_network' }
  include_context 'chef context'

  it 'creates it when it does not exist' do
    expect_any_instance_of(OneviewSDK::FCoENetwork).to receive(:exists?).and_return(false)
    expect_any_instance_of(OneviewSDK::ManagedSAN).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::FCoENetwork).to receive(:create).and_return(true)
    expect(real_chef_run).to create_oneview_fcoe_network('FCoENetwork1')
  end

  it 'updates it when it exists but not alike' do
    expect_any_instance_of(OneviewSDK::FCoENetwork).to receive(:exists?).and_return(true)
    expect_any_instance_of(OneviewSDK::FCoENetwork).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::FCoENetwork).to receive(:like?).and_return(false)
    expect_any_instance_of(OneviewSDK::ManagedSAN).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::FCoENetwork).to receive(:update).and_return(true)
    expect(real_chef_run).to create_oneview_fcoe_network('FCoENetwork1')
  end

  it 'does nothing when it exists and is alike' do
    expect_any_instance_of(OneviewSDK::FCoENetwork).to receive(:exists?).and_return(true)
    expect_any_instance_of(OneviewSDK::FCoENetwork).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::FCoENetwork).to receive(:like?).and_return(true)
    expect_any_instance_of(OneviewSDK::ManagedSAN).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::FCoENetwork).to_not receive(:update)
    expect_any_instance_of(OneviewSDK::FCoENetwork).to_not receive(:create)
    expect(real_chef_run).to create_oneview_fcoe_network('FCoENetwork1')
  end

  it 'fails if the SAN is not found' do
    expect_any_instance_of(OneviewSDK::ManagedSAN).to receive(:retrieve!).and_return(false)
    expect { real_chef_run }.to raise_error(RuntimeError, /'SAN1' not found!/)
  end
end
