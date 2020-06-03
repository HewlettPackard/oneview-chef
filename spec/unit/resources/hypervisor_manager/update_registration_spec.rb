require_relative './../../../spec_helper'

describe 'oneview_test_api800_c7000::hypervisor_manager_update_registration' do
  let(:resource_name) { 'hypervisor_manager' }
  include_context 'chef context'

  it 'update hypervisor registration with different IP' do
    expect_any_instance_of(OneviewSDK::API800::C7000::HypervisorManager).to receive(:exists?).and_return(true)
    expect_any_instance_of(OneviewSDK::API800::C7000::HypervisorManager).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(OneviewSDK::API800::C7000::HypervisorManager).to receive(:like?).and_return(true)
    expect(real_chef_run).to update_registration_oneview_hypervisor_manager('172.18.13.11')
  end
end
