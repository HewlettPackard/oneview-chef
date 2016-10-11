require_relative './../../../spec_helper'

describe 'oneview_test::volume_create_snapshot' do
  let(:resource_name) { 'volume' }
  include_context 'chef context'

  it 'raises error when resource does not exists' do
    expect_any_instance_of(OneviewSDK::Volume).to receive(:exists?).and_return(false)
    expect { real_chef_run }.to raise_error(/Resource not found: oneview_volume 'Volume1'/)
  end

  it 'does nothing when a snapshot already exists with the same name' do
    allow_any_instance_of(OneviewSDK::Volume).to receive(:exists?).and_return(true)
    allow_any_instance_of(OneviewSDK::Volume).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::Volume).to receive(:get_snapshot).and_return(['name' => 'Snapshot1'])
    expect_any_instance_of(OneviewSDK::Volume).to_not receive(:create_snapshot)
    expect(real_chef_run).to create_oneview_volume_snapshot('Volume1')
  end

  it 'creates a snapshot when it does not exists' do
    allow_any_instance_of(OneviewSDK::Volume).to receive(:exists?).and_return(true)
    allow_any_instance_of(OneviewSDK::Volume).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::Volume).to receive(:get_snapshot).and_return([])
    expect_any_instance_of(OneviewSDK::Volume).to receive(:create_snapshot).and_return(true)
    expect(real_chef_run).to create_oneview_volume_snapshot('Volume1')
  end
end

describe 'oneview_test::volume_create_snapshot_invalid' do
  let(:resource_name) { 'volume' }
  include_context 'chef context'

  it 'needs snapshot_data attribute' do
    expect { real_chef_run }.to raise_error(/Unspecified property: 'snapshot_data'. Please set it before attempting this action./)
  end
end
