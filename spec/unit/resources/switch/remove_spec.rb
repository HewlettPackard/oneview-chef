require_relative './../../../spec_helper'

describe 'oneview_test::switch_remove' do
  let(:resource_name) { 'switch' }
  include_context 'chef context'

  it 'removes it when it exists and is not in the inventory' do
    allow_any_instance_of(OneviewSDK::Switch).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::Switch).to receive(:[]).with('name').and_return('Switch1')
    allow_any_instance_of(OneviewSDK::Switch).to receive(:[]).with('state').and_return('Unsupported')
    expect_any_instance_of(OneviewSDK::Switch).to receive(:remove).and_return(true)
    expect(real_chef_run).to remove_oneview_switch('Switch1')
  end

  it 'removes it when it exists and is already in the inventory' do
    allow_any_instance_of(OneviewSDK::Switch).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::Switch).to receive(:[]).with('name').and_return('Switch1')
    allow_any_instance_of(OneviewSDK::Switch).to receive(:[]).with('state').and_return('Inventory')
    expect_any_instance_of(OneviewSDK::Switch).to_not receive(:remove).and_return(true)
    expect(real_chef_run).to remove_oneview_switch('Switch1')
  end

  it 'does nothing when it does not exist' do
    allow_any_instance_of(OneviewSDK::Switch).to receive(:retrieve!).and_return(false)
    expect_any_instance_of(OneviewSDK::Switch).to_not receive(:remove)
    expect(real_chef_run).to remove_oneview_switch('Switch1')
  end
end
