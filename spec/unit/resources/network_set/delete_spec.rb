require_relative './../../../spec_helper'

describe 'oneview_test::network_set_delete' do
  let(:resource_name) { 'network_set' }
  include_context 'chef context'

  it 'deletes it when it exists' do
    expect_any_instance_of(OneviewSDK::NetworkSet).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::NetworkSet).to receive(:delete).and_return(true)
    expect(real_chef_run).to delete_oneview_network_set('NetworkSet3')
  end

  it 'does nothing when it does not exist' do
    expect_any_instance_of(OneviewSDK::NetworkSet).to receive(:retrieve!).and_return(false)
    expect_any_instance_of(OneviewSDK::NetworkSet).to_not receive(:delete)
    expect(real_chef_run).to delete_oneview_network_set('NetworkSet3')
  end
end
