require_relative './../../../spec_helper'

describe 'oneview_test::datacenter_add' do
  let(:resource_name) { 'datacenter' }
  include_context 'chef context'

  it 'adds it when it does not exist' do
    expect_any_instance_of(OneviewSDK::Datacenter).to receive(:exists?).and_return(false)
    expect_any_instance_of(OneviewSDK::Rack).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::Datacenter).to receive(:add_rack).with(instance_of(OneviewSDK::Rack), 100, 20, 0)
    expect_any_instance_of(OneviewSDK::Datacenter).to receive(:add).and_return(true)
    expect(real_chef_run).to add_oneview_datacenter('Datacenter1')
  end

  it 'updates it when it exists but not alike' do
    expect_any_instance_of(OneviewSDK::Datacenter).to receive(:exists?).and_return(true)
    expect_any_instance_of(OneviewSDK::Rack).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::Datacenter).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::Datacenter).to receive(:like?).and_return(false)
    expect_any_instance_of(OneviewSDK::Datacenter).to receive(:update).and_return(true)
    expect(real_chef_run).to add_oneview_datacenter('Datacenter1')
  end

  it 'does nothing when it exists and is alike' do
    expect_any_instance_of(OneviewSDK::Datacenter).to receive(:exists?).and_return(true)
    expect_any_instance_of(OneviewSDK::Rack).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::Datacenter).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::Datacenter).to receive(:like?).and_return(true)
    expect_any_instance_of(OneviewSDK::Datacenter).to_not receive(:update)
    expect_any_instance_of(OneviewSDK::Datacenter).to_not receive(:add)
    expect(real_chef_run).to add_oneview_datacenter('Datacenter1')
  end
end
