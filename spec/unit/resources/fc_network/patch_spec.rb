require_relative './../../../spec_helper'

describe 'oneview_test_api300_synergy::fc_network_patch' do
  let(:resource_name) { 'fc_network' }
  include_context 'chef context'

  it 'performs patch operation' do
    expect_any_instance_of(OneviewSDK::API300::Synergy::FCNetwork).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::API300::Synergy::FCNetwork).to receive(:patch).with('test', 'test/', 'TestMessage').and_return(true)
    expect(real_chef_run).to patch_oneview_fc_network('FCNetwork4')
  end
end
