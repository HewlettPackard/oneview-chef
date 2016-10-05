require_relative './../../../spec_helper'

describe 'oneview_test::unmanaged_device_add' do
  let(:resource_name) { 'unmanaged_device' }
  include_context 'chef context'

  it 'adds it when it does not exist' do
    allow_any_instance_of(OneviewSDK::UnmanagedDevice).to receive(:exists?).and_return(false)
    expect_any_instance_of(OneviewSDK::UnmanagedDevice).to receive(:add).and_return(true)
    expect(real_chef_run).to add_oneview_unmanaged_device('UnmanagedDevice1')
  end

  it 'updates it when it exists but not alike' do
    allow_any_instance_of(OneviewSDK::UnmanagedDevice).to receive(:exists?).and_return(true)
    allow_any_instance_of(OneviewSDK::UnmanagedDevice).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::UnmanagedDevice).to receive(:like?).and_return(false)
    expect_any_instance_of(OneviewSDK::UnmanagedDevice).to receive(:update).and_return(true)
    expect(real_chef_run).to add_oneview_unmanaged_device('UnmanagedDevice1')
  end

  it 'does nothing when it exists and is alike' do
    allow_any_instance_of(OneviewSDK::UnmanagedDevice).to receive(:exists?).and_return(true)
    allow_any_instance_of(OneviewSDK::UnmanagedDevice).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::UnmanagedDevice).to receive(:like?).and_return(true)
    expect_any_instance_of(OneviewSDK::UnmanagedDevice).to_not receive(:update)
    expect_any_instance_of(OneviewSDK::UnmanagedDevice).to_not receive(:add)
    expect(real_chef_run).to add_oneview_unmanaged_device('UnmanagedDevice1')
  end
end
