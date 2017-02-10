require_relative './../../../spec_helper'

describe 'oneview_test::resource_create' do
  let(:resource_name) { 'resource' }
  include_context 'chef context'
  let(:klass) { OneviewSDK::API200::EthernetNetwork }

  it 'requires a valid resource type' do
    expect(OneviewSDK).to receive(:resource_named).and_return(nil)
    expect { real_chef_run }.to raise_error(RuntimeError, /Please use a valid type/)
  end

  it 'creates EthernetNetwork1 when it does not exist' do
    expect_any_instance_of(klass).to receive(:exists?).and_return(false)
    expect_any_instance_of(klass).to receive(:create).and_return(true)
    expect(real_chef_run).to create_oneview_resource('EthernetNetwork1')
  end

  it 'updates EthernetNetwork1 when it exists but not alike' do
    expect_any_instance_of(klass).to receive(:exists?).and_return(true)
    expect_any_instance_of(klass).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(klass).to receive(:like?).and_return(false)
    expect_any_instance_of(klass).to receive(:update).and_return(true)
    expect(real_chef_run).to create_oneview_resource('EthernetNetwork1')
  end

  it 'does nothing when EthernetNetwork1 exists and is alike' do
    expect_any_instance_of(klass).to receive(:exists?).and_return(true)
    expect_any_instance_of(klass).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(klass).to receive(:like?).and_return(true)
    expect_any_instance_of(klass).to_not receive(:update)
    expect_any_instance_of(klass).to_not receive(:create)
    expect(real_chef_run).to create_oneview_resource('EthernetNetwork1')
  end
end

describe 'oneview_test_api300_synergy::resource_create' do
  let(:resource_name) { 'resource' }
  include_context 'chef context'
  let(:klass) { OneviewSDK::API300::Synergy::EthernetNetwork }

  it 'requires a valid resource type' do
    expect(OneviewSDK).to receive(:resource_named).and_return(nil)
    expect { real_chef_run }.to raise_error(RuntimeError, /Please use a valid type/)
  end

  it 'creates EthernetNetwork1 when it does not exist' do
    expect_any_instance_of(klass).to receive(:exists?).and_return(false)
    expect_any_instance_of(klass).to receive(:create).and_return(true)
    expect(real_chef_run).to create_oneview_resource('EthernetNetwork1')
  end
end
