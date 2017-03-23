require_relative './../../../spec_helper'

describe 'oneview_test::volume_delete_snapshot' do
  let(:resource_name) { 'volume' }
  include_context 'chef context'

  it 'raises error when resource does not exists' do
    expect_any_instance_of(OneviewSDK::Volume).to receive(:retrieve!).and_return(false)
    expect { real_chef_run }.to raise_error(RuntimeError, /not found/)
  end

  it 'does nothin when it does not exists' do
    allow_any_instance_of(OneviewSDK::Volume).to receive(:exists?).and_return(true)
    allow_any_instance_of(OneviewSDK::Volume).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::Volume).to receive(:get_snapshot).and_return([])
    expect_any_instance_of(OneviewSDK::Volume).to_not receive(:create_snapshot).and_return(true)
    expect(real_chef_run).to delete_oneview_volume_snapshot('Volume1')
  end

  it 'deletes when exists' do
    allow_any_instance_of(OneviewSDK::Volume).to receive(:exists?).and_return(true)
    allow_any_instance_of(OneviewSDK::Volume).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::Volume).to receive(:get_snapshot).and_return(['name' => 'Snapshot1'])
    expect_any_instance_of(OneviewSDK::Volume).to receive(:delete_snapshot)
    expect(real_chef_run).to delete_oneview_volume_snapshot('Volume1')
  end
end
