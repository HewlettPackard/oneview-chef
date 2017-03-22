require_relative './../../../spec_helper'

describe 'oneview_test::server_profile_template_new_profile' do
  let(:resource_name) { 'server_profile_template' }
  include_context 'chef context'

  it 'creates it when it does not exist' do
    expect_any_instance_of(OneviewSDK::ServerProfileTemplate).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::ServerProfileTemplate).to receive(:new_profile).and_return(OneviewSDK::ServerProfile.new(client))
    expect_any_instance_of(OneviewSDK::ServerProfile).to receive(:exists?).and_return(false)
    expect_any_instance_of(OneviewSDK::ServerProfile).to receive(:create).and_return(true)
    expect(real_chef_run).to new_oneview_server_profile_template_profile('ServerProfileTemplate1')
  end
end
