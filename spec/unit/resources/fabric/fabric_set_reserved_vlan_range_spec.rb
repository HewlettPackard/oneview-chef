require_relative './../../../spec_helper'

describe 'oneview_test_api300_synergy::fabric_set_reserved_vlan_range' do
  let(:resource_name) { 'fabric' }
  include_context 'chef context'

  let(:range) do
    {
      'start' => 1200,
      'length' => 120,
      'type' => 'vlan-pool'
    }
  end

  it 'updates it when it does not match' do
    expect_any_instance_of(OneviewSDK::API300::Synergy::Fabric).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::API300::Synergy::Fabric).to receive(:like?).and_return(false)
    expect_any_instance_of(OneviewSDK::API300::Synergy::Fabric).to receive(:set_reserved_vlan_range)
      .with(range).and_return(range)
    expect(real_chef_run).to set_oneview_fabric_reserved_vlan_range('Fabric1')
  end

  it 'fails if the resource is not found' do
    expect_any_instance_of(OneviewSDK::API300::Synergy::Fabric).to receive(:retrieve!).and_return(false)
    expect { real_chef_run }.to raise_error(RuntimeError, /not found/)
  end
end
