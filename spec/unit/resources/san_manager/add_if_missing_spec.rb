require_relative './../../../spec_helper'

describe 'oneview_test::san_manager_add_if_missing' do
  let(:resource_name) { 'san_manager' }
  include_context 'chef context'

  it 'san manager does not exist' do
    allow_any_instance_of(OneviewSDK::SANManager).to receive(:exists?).and_return(false)
    expect_any_instance_of(OneviewSDK::SANManager).to receive(:add).and_return(true)
    expect(real_chef_run).to add_oneview_san_manager_if_missing('172.18.15.1')
  end

  it 'san manager already exists' do
    allow_any_instance_of(OneviewSDK::SANManager).to receive(:exists?).and_return(true)
    allow_any_instance_of(OneviewSDK::SANManager).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::SANManager).to_not receive(:add)
    expect(real_chef_run).to add_oneview_san_manager_if_missing('172.18.15.1')
  end
end
