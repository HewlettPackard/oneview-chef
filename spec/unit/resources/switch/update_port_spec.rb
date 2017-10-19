require_relative './../../../spec_helper'

describe 'oneview_test_api300_synergy::switch_update_port' do
  let(:resource_name) { 'switch' }
  include_context 'chef context'
  include_context 'shared context'

  let(:target_class) { OneviewSDK::API300::C7000::Switch }

  it 'updates the port' do
    ports = [
      { 'name' => '1.1', 'enabled' => false },
      { 'name' => '1.2', 'enabled' => true }
    ]
    switch = target_class.new(@client, uri: '/rest/fake', ports: ports)
    allow(target_class).to receive(:find_by).and_return([switch])
    expect_any_instance_of(target_class).to receive(:update_port).with('1.1', anything).and_return(true)
    expect(real_chef_run).to update_oneview_switch_port('Switch1')
  end

  it 'leaves it as is since it is up to date' do
    ports = [
      { 'name' => '1.1', 'enabled' => true },
      { 'name' => '1.2', 'enabled' => true }
    ]
    switch = target_class.new(@client, uri: '/rest/fake', ports: ports)
    allow(target_class).to receive(:find_by).and_return([switch])
    expect_any_instance_of(target_class).to_not receive(:update_port)
    expect(real_chef_run).to update_oneview_switch_port('Switch1')
  end

  it 'fails when trying to update an unexistant port' do
    ports = [
      { 'name' => '1.2', 'enabled' => true },
      { 'name' => '1.3', 'enabled' => true }
    ]
    switch = target_class.new(@client, uri: '/rest/fake', ports: ports)
    allow(target_class).to receive(:find_by).and_return([switch])
    expect { real_chef_run }.to raise_error(RuntimeError, /Could not find port/)
  end

  it 'fails if the resource is not found' do
    expect_any_instance_of(target_class).to receive(:retrieve!).and_return(false)
    expect { real_chef_run }.to raise_error(RuntimeError, /not found/)
  end
end
