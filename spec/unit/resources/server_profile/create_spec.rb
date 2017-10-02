require_relative './../../../spec_helper'

describe 'oneview_test::server_profile_create' do
  let(:resource_name) { 'server_profile' }
  include_context 'chef context'

  let(:target_class) { OneviewSDK::API200::ServerProfile }

  it 'creates it when it does not exist' do
    expect_any_instance_of(target_class).to receive(:exists?).and_return(false)
    expect_any_instance_of(target_class).to receive(:create).and_return(true)
    expect(real_chef_run).to create_oneview_server_profile('ServerProfile1')
  end

  it 'updates it when it exists but not alike' do
    expect_any_instance_of(target_class).to receive(:exists?).and_return(true)
    expect_any_instance_of(target_class).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(target_class).to receive(:like?).and_return(false)
    expect_any_instance_of(target_class).to receive(:update).and_return(true)
    expect(real_chef_run).to create_oneview_server_profile('ServerProfile1')
  end

  it 'does nothing when it exists and is alike' do
    expect_any_instance_of(target_class).to receive(:exists?).and_return(true)
    expect_any_instance_of(target_class).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(target_class).to receive(:like?).and_return(true)
    expect_any_instance_of(target_class).to_not receive(:update)
    expect_any_instance_of(target_class).to_not receive(:create)
    expect(real_chef_run).to create_oneview_server_profile('ServerProfile1')
  end

  it 'does not build volume attachments' do
    expect_any_instance_of(target_class).to receive(:exists?).and_return(false)
    expect_any_instance_of(target_class).to receive(:create).and_return(true)
    expect_any_instance_of(target_class).to_not receive(:add_volume_attachment)
    expect_any_instance_of(target_class).to_not receive(:create_volume_with_attachment)
    expect(real_chef_run).to create_oneview_server_profile('ServerProfile1')
  end
end
