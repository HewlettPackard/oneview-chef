require_relative './../../../spec_helper'

describe 'oneview_test::managed_san_set_policy' do
  let(:resource_name) { 'managed_san' }
  include_context 'chef context'

  it 'fails whe it does not exist' do
    allow_any_instance_of(OneviewSDK::ManagedSAN).to receive(:exists?).and_return(false)
    expect { real_chef_run }.to raise_error(RuntimeError, /Resource not found: oneview_managed_san 'ManagedSAN1'/)
  end

  it 'sets the policy if it is no alike' do
    allow_any_instance_of(OneviewSDK::ManagedSAN).to receive(:exists?).and_return(true)
    allow_any_instance_of(OneviewSDK::ManagedSAN).to receive(:retrieve!).and_call_original
    allow(OneviewSDK::ManagedSAN).to receive(:find_by).and_return(
      [
        OneviewSDK::ManagedSAN.new(
          client,
          name: 'ManagedSAN1',
          sanPolicy: {
            'zoningPolicy' => 'SingleInitiatorAllTargets',
            'zoneNameFormat' => '{hostName}_{initiatorWwn}',
            'enableAliasing' => false,
            'initiatorNameFormat' => '{hostName}_{initiatorWwn}',
            'targetNameFormat' => '{storageSystemName}_{targetName}',
            'targetGroupNameFormat' => '{storageSystemName}_{targetGroupName}'
          }
        )
      ]
    )
    expect_any_instance_of(OneviewSDK::ManagedSAN).to receive(:set_san_policy).and_return(true)
    expect(real_chef_run).to set_oneview_managed_san_policy('ManagedSAN1')
  end

  it 'does nothing when it exists and is alike' do
    allow_any_instance_of(OneviewSDK::ManagedSAN).to receive(:exists?).and_return(true)
    allow_any_instance_of(OneviewSDK::ManagedSAN).to receive(:retrieve!).and_call_original
    allow(OneviewSDK::ManagedSAN).to receive(:find_by).and_return(
      [
        OneviewSDK::ManagedSAN.new(
          client,
          name: 'ManagedSAN1',
          sanPolicy: {
            'zoningPolicy' => 'SingleInitiatorAllTargets',
            'zoneNameFormat' => '{hostName}_{initiatorWwn}',
            'enableAliasing' => true,
            'initiatorNameFormat' => '{hostName}_{initiatorWwn}',
            'targetNameFormat' => '{storageSystemName}_{targetName}',
            'targetGroupNameFormat' => '{storageSystemName}_{targetGroupName}'
          }
        )
      ]
    )
    expect_any_instance_of(OneviewSDK::ManagedSAN).to_not receive(:set_san_policy)
    expect(real_chef_run).to set_oneview_managed_san_policy('ManagedSAN1')
  end
end
