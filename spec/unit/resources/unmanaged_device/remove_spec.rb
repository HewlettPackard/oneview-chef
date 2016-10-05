require_relative './../../../spec_helper'

describe 'oneview_test::unmanaged_device_remove' do
  let(:resource_name) { 'unmanaged_device' }
  include_context 'chef context'

  it 'removes it when it exists' do
    allow_any_instance_of(OneviewSDK::UnmanagedDevice).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::UnmanagedDevice).to receive(:remove).and_return(true)
    expect(real_chef_run).to remove_oneview_unmanaged_device('UnmanagedDevice1')
  end

  it 'does nothing when it does not exist' do
    allow_any_instance_of(OneviewSDK::UnmanagedDevice).to receive(:retrieve!).and_return(false)
    expect_any_instance_of(OneviewSDK::UnmanagedDevice).to_not receive(:remove)
    expect(real_chef_run).to remove_oneview_unmanaged_device('UnmanagedDevice1')
  end
end
