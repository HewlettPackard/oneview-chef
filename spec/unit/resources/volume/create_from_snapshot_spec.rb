require_relative './../../../spec_helper'

describe 'oneview_test_api500_synergy::volume_create_from_snapshot' do
  let(:resource_name) { 'volume' }
  include_context 'chef context'

  let(:base_sdk) { OneviewSDK::API500::Synergy }
  let(:target_class) { base_sdk::Volume }

  it 'creates VOL2 when it does not exist' do
    allow_any_instance_of(target_class).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(target_class).to receive(:exists?).and_return(false)
    expect_any_instance_of(target_class).to receive(:create_from_snapshot).and_return(true)
    expect(real_chef_run).to create_oneview_volume_from_snapshot('VOL1')
  end

  it 'does nothing when VOL2 exists' do
    allow_any_instance_of(target_class).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(target_class).to receive(:exists?).and_return(true)
    expect_any_instance_of(target_class).to_not receive(:create_from_snapshot)
    expect(real_chef_run).to create_oneview_volume_from_snapshot('VOL1')
  end

  it 'does nothing when VOL1 that has the snapshot does not exist' do
    allow_any_instance_of(target_class).to receive(:retrieve!).and_return(false)
    expect_any_instance_of(target_class).to_not receive(:create_from_snapshot)
    expect { real_chef_run }.to raise_error(RuntimeError, /'VOL1' not found/)
  end
end
