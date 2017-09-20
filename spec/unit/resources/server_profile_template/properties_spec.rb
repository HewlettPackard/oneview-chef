
require_relative './../../../spec_helper'

describe 'oneview_test::server_profile_template_properties' do
  let(:resource_name) { 'server_profile_template' }
  include_context 'chef context'
  include_context 'shared context'

  let(:provider) { OneviewCookbook::API200::ServerProfileTemplateProvider }

  it 'loads the associated resources' do
    sh1 = OneviewSDK::ServerHardwareType.new(@client, name: 'ServerHardwareType1', uri: 'rest/fake0')
    en1 = OneviewSDK::EthernetNetwork.new(@client, name: 'EthernetNetwork1', uri: 'rest/fake1')
    allow_any_instance_of(provider).to receive(:load_resource).and_call_original
    allow_any_instance_of(provider).to receive(:load_resource).with(anything, 'ServerHardwareType1').and_return(sh1)
    allow_any_instance_of(provider).to receive(:load_resource).with(anything, 'EthernetNetwork1').and_return(en1)
    expect_any_instance_of(OneviewSDK::ServerProfileTemplate).to receive(:set_server_hardware_type).with(sh1)
    expect_any_instance_of(OneviewSDK::ServerProfileTemplate).to receive(:add_connection).with(en1, 'it' => 'works')

    # Mock create
    expect_any_instance_of(OneviewSDK::ServerProfileTemplate).to receive(:exists?).and_return(false)
    expect_any_instance_of(OneviewSDK::ServerProfileTemplate).to receive(:create).and_return(true)

    expect(real_chef_run).to create_oneview_server_profile_template('ServerProfileTemplate1')
  end
end

describe 'oneview_test_api500_synergy::server_profile_template_properties' do
  let(:resource_name) { 'server_profile_template' }
  include_context 'chef context'
  include_context 'shared context'

  let(:provider) { OneviewCookbook::API500::Synergy::ServerProfileTemplateProvider }
  let(:base_sdk) { OneviewSDK::API500::Synergy }

  it 'loads the associated resource OS Deployment Plan adding the customAttributes' do
    osdp = base_sdk::OSDeploymentPlan.new(@client, name: 'OSDeploymentPlan1', uri: 'rest/fake0', additionalParameters: [])
    allow_any_instance_of(provider).to receive(:load_resource).and_call_original
    allow_any_instance_of(provider).to receive(:load_resource)
      .with(:OSDeploymentPlan, 'OSDeploymentPlan1').and_return(osdp)

    expect_any_instance_of(base_sdk::ServerProfileTemplate).to receive(:set_os_deployment_settings)
      .with(osdp, ['name' => 'it', 'value' => 'works'])

    # Mock create
    expect_any_instance_of(base_sdk::ServerProfileTemplate).to receive(:exists?).and_return(false)
    expect_any_instance_of(base_sdk::ServerProfileTemplate).to receive(:create).and_return(true)

    expect(real_chef_run).to create_oneview_server_profile_template('ServerProfileTemplate1')
  end

  it 'loads the associated resource OS Deployment Plan adding the osCustomAttributes' do
    osdp = base_sdk::OSDeploymentPlan.new(@client, name: 'OSDeploymentPlan1', uri: 'rest/fake0', additionalParameters: [])
    allow_any_instance_of(provider).to receive(:load_resource).and_call_original
    allow_any_instance_of(provider).to receive(:load_resource)
      .with(:OSDeploymentPlan, 'OSDeploymentPlan1').and_return(osdp)

    allow_any_instance_of(base_sdk::ServerProfileTemplate).to receive(:[]).and_call_original
    allow_any_instance_of(base_sdk::ServerProfileTemplate).to receive(:[]).with('osDeploymentSettings')
                                                                          .and_return('osCustomAttributes' => ['name' => 'works', 'value' => 'too'])

    expect_any_instance_of(base_sdk::ServerProfileTemplate).to receive(:set_os_deployment_settings)
      .with(osdp, ['name' => 'works', 'value' => 'too'])

    # Mock create
    expect_any_instance_of(base_sdk::ServerProfileTemplate).to receive(:exists?).and_return(false)
    expect_any_instance_of(base_sdk::ServerProfileTemplate).to receive(:create).and_return(true)

    expect(real_chef_run).to create_oneview_server_profile_template('ServerProfileTemplate1')
  end

  it 'loads the associated resource OS Deployment Plan merging the osCustomAttributes' do
    osdp = base_sdk::OSDeploymentPlan.new(@client,
                                          name: 'OSDeploymentPlan1',
                                          uri: 'rest/fake0',
                                          additionalParameters: [
                                            { 'name' => 'a', 'value' => 'default' },
                                            { 'name' => 'c', 'value' => 'default' }
                                          ])
    allow_any_instance_of(provider).to receive(:load_resource).and_call_original
    allow_any_instance_of(provider).to receive(:load_resource).with(:OSDeploymentPlan, 'OSDeploymentPlan1').and_return(osdp)

    allow_any_instance_of(base_sdk::ServerProfileTemplate).to receive(:[]).and_call_original
    allow_any_instance_of(base_sdk::ServerProfileTemplate)
      .to receive(:[])
      .with('osDeploymentSettings')
      .and_return('osCustomAttributes' => [{ 'name' => 'b', 'value' => 'custom' },
                                           { 'name' => 'c', 'value' => 'override' },
                                           { 'name' => 'd', 'value' => 'custom' }])

    expect_any_instance_of(base_sdk::ServerProfileTemplate).to receive(:set_os_deployment_settings)
      .with(osdp, a_collection_containing_exactly({ 'name' => 'a', 'value' => 'default' },
                                                  { 'name' => 'b', 'value' => 'custom' },
                                                  { 'name' => 'c', 'value' => 'override' },
                                                  'name' => 'd', 'value' => 'custom'))

    # Mock create
    expect_any_instance_of(base_sdk::ServerProfileTemplate).to receive(:exists?).and_return(false)
    expect_any_instance_of(base_sdk::ServerProfileTemplate).to receive(:create).and_return(true)

    expect(real_chef_run).to create_oneview_server_profile_template('ServerProfileTemplate1')
  end
end
