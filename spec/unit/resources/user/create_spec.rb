require_relative './../../../spec_helper'

klass = OneviewSDK::API200::User
describe 'oneview_test::user_create' do
  let(:resource_name) { 'user' }
  include_context 'chef context'

  it 'creates it when it does not exist' do
    expect_any_instance_of(klass).to receive(:exists?).twice.and_return(false)
    expect_any_instance_of(klass).to receive(:create).and_return(true)
    expect(real_chef_run).to create_oneview_user('User1')
  end

  it 'updates it and the password when it exists but is not alike' do
    expect_any_instance_of(klass).to receive(:exists?).twice.and_return(true)
    expect_any_instance_of(klass).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(klass).to receive(:like?).and_return(false)
    expect_any_instance_of(klass).to receive(:update).once.and_return(true)
    expect_any_instance_of(klass).to receive(:update).with(password: 'secret123').once.and_return(true)
    expect(OneviewSDK::Client).to receive(:new).once.and_call_original
    expect(OneviewSDK::Client).to receive(:new).once.and_raise(OneviewSDK::BadRequest, 'Invalid username or password')
    expect(Chef::Log).to_not receive(:info).with(/password is up to date/)
    expect(real_chef_run).to create_oneview_user('User1')
  end

  it 'only updates the password when it exists and is alike' do
    expect_any_instance_of(klass).to receive(:exists?).twice.and_return(true)
    expect_any_instance_of(klass).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(klass).to receive(:like?).and_return(true)
    expect_any_instance_of(klass).to_not receive(:create)
    expect_any_instance_of(klass).to receive(:update).once.with(password: 'secret123').and_return(true)
    expect(OneviewSDK::Client).to receive(:new).once.and_call_original
    expect(OneviewSDK::Client).to receive(:new).once.and_raise(OneviewSDK::BadRequest, 'Invalid username or password')
    expect(Chef::Log).to_not receive(:info).with(/password is up to date/)
    expect(real_chef_run).to create_oneview_user('User1')
  end

  it 'prints out a message saying the password is unchanged' do
    expect_any_instance_of(klass).to receive(:exists?).twice.and_return(true)
    expect_any_instance_of(klass).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(klass).to receive(:like?).and_return(true)
    expect_any_instance_of(klass).to_not receive(:update)
    expect_any_instance_of(klass).to_not receive(:create)
    expect(Chef::Log).to receive(:info).at_least(:once).with(/password is up to date/)
    expect(Chef::Log).to receive(:info).at_least(:once).with(anything)
    expect(real_chef_run).to create_oneview_user('User1')
  end
end
