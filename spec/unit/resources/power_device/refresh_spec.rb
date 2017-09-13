require_relative './../../../spec_helper'

describe 'oneview_test::power_device_refresh' do
  let(:resource_name) { 'power_device' }
  include_context 'chef context'

  let(:target_class) { OneviewSDK::API200::PowerDevice }

  context 'when Oneview resource can be retrieved' do
    before do
      allow_any_instance_of(target_class).to receive(:retrieve!).and_return(true)
      allow_any_instance_of(target_class).to receive(:[]).with('name').and_call_original
    end

    it 'refreshes it when it current state is ""' do
      allow_any_instance_of(target_class).to receive(:[]).with('refreshState').and_return('')
      expect_any_instance_of(target_class).to receive(:set_refresh_state).with(refreshState: 'RefreshPending')
      expect(real_chef_run).to refresh_oneview_power_device('PowerDevice1')
    end

    it 'refreshes it when it current state is RefreshFailed' do
      allow_any_instance_of(target_class).to receive(:[]).with('refreshState').and_return('RefreshFailed')
      expect_any_instance_of(target_class).to receive(:set_refresh_state).with(refreshState: 'RefreshPending')
      expect(real_chef_run).to refresh_oneview_power_device('PowerDevice1')
    end

    it 'refreshes it when it current state is NotRefreshing' do
      allow_any_instance_of(target_class).to receive(:[]).with('refreshState').and_return('NotRefreshing')
      expect_any_instance_of(target_class).to receive(:set_refresh_state).with(refreshState: 'RefreshPending')
      expect(real_chef_run).to refresh_oneview_power_device('PowerDevice1')
    end

    it 'does nothing when refresh state is RefreshPending' do
      allow_any_instance_of(target_class).to receive(:[]).with('refreshState').and_return('RefreshPending')
      expect_any_instance_of(target_class).not_to receive(:set_refresh_state)
      expect(real_chef_run).to refresh_oneview_power_device('PowerDevice1')
    end
  end

  it 'raises an error when it does not exist' do
    allow_any_instance_of(target_class).to receive(:retrieve!).and_return(false)
    allow(target_class).to receive(:get_ipdu_devices).and_return([])
    expect_any_instance_of(target_class).to_not receive(:set_refresh_state)
    expect { real_chef_run }.to raise_error(StandardError, /not found/)
  end
end
