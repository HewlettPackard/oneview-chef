require_relative './../../../spec_helper'

describe 'oneview_test_api300_c7000::fcoe_network_patch' do
  let(:resource_name) { 'fcoe_network' }
  include_context 'chef context'

  it 'performs patch operation' do
    expect_any_instance_of(OneviewSDK::API300::C7000::FCoENetwork).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::API300::C7000::FCoENetwork).to receive(:patch).with('test', 'test/', 'TestMessage').and_return(true)
    expect(real_chef_run).to patch_oneview_fcoe_network('FCoENetwork1')
  end
end
