require_relative './../../../spec_helper'

describe 'oneview_test::unmanaged_device_add_if_missing' do
  let(:resource_name) { 'unmanaged_device' }
  include_context 'chef context'

  it 'unmanaged device does not exist' do
    allow_any_instance_of(OneviewSDK::UnmanagedDevice).to receive(:exists?).and_return(false)
    expect_any_instance_of(OneviewSDK::UnmanagedDevice).to receive(:add).and_return(true)
    expect(real_chef_run).to add_oneview_unmanaged_device_if_missing('UnmanagedDevice1')
  end

  it 'unmanaged device already exists' do
    allow_any_instance_of(OneviewSDK::UnmanagedDevice).to receive(:exists?).and_return(true)
    allow_any_instance_of(OneviewSDK::UnmanagedDevice).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::UnmanagedDevice).to_not receive(:add)
    expect(real_chef_run).to add_oneview_unmanaged_device_if_missing('UnmanagedDevice1')
  end
end
