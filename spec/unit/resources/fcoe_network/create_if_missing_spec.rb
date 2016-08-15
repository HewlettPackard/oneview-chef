require_relative './../../../spec_helper'

describe 'oneview_test::fcoe_network_create_if_missing' do
  let(:resource_name) { 'fcoe_network' }
  include_context 'chef context'

  it 'creates it when it does not exist' do
    expect_any_instance_of(OneviewSDK::FCoENetwork).to receive(:exists?).and_return(false)
    expect_any_instance_of(OneviewSDK::FCoENetwork).to receive(:create).and_return(true)
    expect(real_chef_run).to create_oneview_fcoe_network_if_missing('FCoENetwork2')
  end

  it 'does nothing when it exists' do
    expect_any_instance_of(OneviewSDK::FCoENetwork).to receive(:exists?).and_return(true)
    expect_any_instance_of(OneviewSDK::FCoENetwork).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::FCoENetwork).to_not receive(:create)
    expect(real_chef_run).to create_oneview_fcoe_network_if_missing('FCoENetwork2')
  end
end
