require_relative './../../../spec_helper'

describe 'oneview_test::datacenter_add_if_missing' do
  let(:resource_name) { 'datacenter' }
  include_context 'chef context'

  it 'adds it when it does not exist' do
    expect_any_instance_of(OneviewSDK::Datacenter).to receive(:exists?).and_return(false)
    expect_any_instance_of(OneviewSDK::Datacenter).to receive(:add).and_return(true)
    expect(real_chef_run).to add_oneview_datacenter_if_missing('Datacenter1')
  end

  it 'does nothing when it exists' do
    expect_any_instance_of(OneviewSDK::Datacenter).to receive(:exists?).and_return(true)
    expect_any_instance_of(OneviewSDK::Datacenter).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::Datacenter).to_not receive(:add)
    expect(real_chef_run).to add_oneview_datacenter_if_missing('Datacenter1')
  end
end
