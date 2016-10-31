require_relative './../../../spec_helper'

describe 'oneview_test::server_profile_delete' do
  let(:resource_name) { 'server_profile' }
  include_context 'chef context'

  it 'deletes it when it exists' do
    expect_any_instance_of(OneviewSDK::ServerProfile).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::ServerProfile).to receive(:delete).and_return(true)
    expect(real_chef_run).to delete_oneview_server_profile('ServerProfile3')
  end

  it 'does nothing when it does not exist' do
    expect_any_instance_of(OneviewSDK::ServerProfile).to receive(:retrieve!).and_return(false)
    expect_any_instance_of(OneviewSDK::ServerProfile).to_not receive(:delete)
    expect(real_chef_run).to delete_oneview_server_profile('ServerProfile3')
  end
end
