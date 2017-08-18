require_relative './../../../spec_helper'

describe 'oneview_test::managed_san_refresh' do
  let(:resource_name) { 'managed_san' }
  include_context 'chef context'

  it 'refresh managed_san already triggered' do
    expect_any_instance_of(OneviewSDK::ManagedSAN).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::ManagedSAN).to receive(:[]).with('refreshState')
                                                                 .and_return('RefreshPending')
    allow_any_instance_of(OneviewSDK::ManagedSAN).to receive(:[]).with('name')
                                                                 .and_return('ManagedSAN1')
    expect_any_instance_of(OneviewSDK::ManagedSAN).to_not receive(:set_refresh_state)
    expect(real_chef_run).to refresh_oneview_managed_san('ManagedSAN1')
  end

  it 'refresh managed_san with default options' do
    expect_any_instance_of(OneviewSDK::ManagedSAN).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::ManagedSAN).to receive(:[]).with('refreshState')
                                                                 .and_return('NotRefreshing')
    allow_any_instance_of(OneviewSDK::ManagedSAN).to receive(:[]).with('name')
                                                                 .and_return('ManagedSAN1')
    expect_any_instance_of(OneviewSDK::ManagedSAN).to receive(:set_refresh_state).and_return(true)
    expect(real_chef_run).to refresh_oneview_managed_san('ManagedSAN1')
  end

  it 'fails if the resource is not found' do
    expect_any_instance_of(OneviewSDK::ManagedSAN).to receive(:retrieve!).and_return(false)
    expect { real_chef_run }.to raise_error(RuntimeError, /not found/)
  end
end
