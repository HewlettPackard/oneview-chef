require_relative './../../../spec_helper'

describe 'oneview_test::datacenter_remove' do
  let(:resource_name) { 'datacenter' }
  include_context 'chef context'

  it 'removes it when it exists' do
    expect_any_instance_of(OneviewSDK::Datacenter).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::Datacenter).to receive(:remove).and_return(true)
    expect(real_chef_run).to remove_oneview_datacenter('Datacenter1')
  end

  it 'does nothing when it does not exist' do
    expect_any_instance_of(OneviewSDK::Datacenter).to receive(:retrieve!).and_return(false)
    expect_any_instance_of(OneviewSDK::Datacenter).to_not receive(:remove)
    expect(real_chef_run).to remove_oneview_datacenter('Datacenter1')
  end
end
