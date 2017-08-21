require_relative './../../../spec_helper'

describe 'oneview_test_api300_synergy::network_set_patch' do
  let(:resource_name) { 'network_set' }
  include_context 'chef context'

  it 'performs patch operation' do
    expect_any_instance_of(OneviewSDK::API300::Synergy::NetworkSet).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::API300::Synergy::NetworkSet).to receive(:patch).with('test', 'test/', 'TestMessage').and_return(true)
    expect(real_chef_run).to patch_oneview_network_set('NetworkSet5')
  end
end
