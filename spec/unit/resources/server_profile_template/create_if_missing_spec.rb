require_relative './../../../spec_helper'

describe 'oneview_test::server_profile_template_create_if_missing' do
  let(:resource_name) { 'server_profile_template' }
  include_context 'chef context'

  it 'creates it when it does not exist' do
    expect_any_instance_of(OneviewSDK::ServerProfileTemplate).to receive(:exists?).and_return(false)
    expect_any_instance_of(OneviewSDK::ServerProfileTemplate).to receive(:create).and_return(true)
    expect(real_chef_run).to create_oneview_server_profile_template_if_missing('ServerProfileTemplate1')
  end

  it 'does nothing when it exists' do
    expect_any_instance_of(OneviewSDK::ServerProfileTemplate).to receive(:exists?).and_return(true)
    expect_any_instance_of(OneviewSDK::ServerProfileTemplate).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::ServerProfileTemplate).to_not receive(:create)
    expect(real_chef_run).to create_oneview_server_profile_template_if_missing('ServerProfileTemplate1')
  end
end
