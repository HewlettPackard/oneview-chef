require_relative './../../../spec_helper'

describe 'oneview_test::san_manager_remove' do
  let(:resource_name) { 'san_manager' }
  include_context 'chef context'

  it 'removes it when it exists' do
    allow_any_instance_of(OneviewSDK::SANManager).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::SANManager).to receive(:remove).and_return(true)
    expect(real_chef_run).to remove_oneview_san_manager('172.18.15.1')
  end

  it 'does nothing when it does not exist' do
    allow_any_instance_of(OneviewSDK::SANManager).to receive(:retrieve!).and_return(false)
    expect_any_instance_of(OneviewSDK::SANManager).to_not receive(:remove)
    expect(real_chef_run).to remove_oneview_san_manager('172.18.15.1')
  end
end
