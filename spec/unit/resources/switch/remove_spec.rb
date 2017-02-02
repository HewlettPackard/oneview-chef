require_relative './../../../spec_helper'

describe 'oneview_test::switch_remove' do
  let(:resource_name) { 'switch' }
  include_context 'chef context'

  let(:klass) { OneviewSDK::API200::Switch }

  before(:each) do
    allow_any_instance_of(klass).to receive(:[]).and_call_original
  end

  it 'removes it when it exists and is not in the inventory' do
    allow_any_instance_of(klass).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(klass).to receive(:[]).with('state').and_return('Unsupported')
    expect_any_instance_of(klass).to receive(:remove).and_return(true)
    expect(real_chef_run).to remove_oneview_switch('Switch1')
  end

  it 'does not remove it when it exists and is already in the inventory' do
    allow_any_instance_of(klass).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(klass).to receive(:[]).with('state').and_return('Inventory')
    expect_any_instance_of(klass).to_not receive(:remove)
    expect(real_chef_run).to remove_oneview_switch('Switch1')
  end

  it 'does nothing when it does not exist' do
    allow_any_instance_of(klass).to receive(:retrieve!).and_return(false)
    expect_any_instance_of(klass).to_not receive(:remove)
    expect(real_chef_run).to remove_oneview_switch('Switch1')
  end
end
