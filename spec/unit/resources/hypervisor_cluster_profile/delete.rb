require_relative './../../../spec_helper'

describe 'oneview_test_api1600_c7000::hypervisor_cluster_profile_delete' do
  let(:resource_name) { 'hypervisor_cluster_profile' }
  include_context 'chef context'
  let(:target_class) { OneviewSDK::API1600::C7000::HypervisorClusterProfile }

  it 'removes it with soft delete if it exist' do
    expect_any_instance_of(target_class).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(target_class).to receive(:delete).and_return(true)
    expect(real_chef_run).to delete_oneview_hypervisor_cluster_profile('ClusterProfile1', true, false)
  end

  it 'removes it if it exist' do
    expect_any_instance_of(target_class).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(target_class).to receive(:delete).and_return(true)
    expect(real_chef_run).to delete_oneview_hypervisor_cluster_profile('ClusterProfile1')
  end

  it 'removes it if it doesnot exist' do
    expect_any_instance_of(target_class).to receive(:retrieve!).and_return(false)
    expect_any_instance_of(target_class).to_not receive(:delete)
    expect(real_chef_run).to delete_oneview_hypervisor_cluster_profile('ClusterProfile1')
  end
end
