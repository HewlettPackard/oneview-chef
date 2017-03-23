require_relative './../../../spec_helper'

describe 'oneview_test::managed_san_set_public_attributes' do
  let(:resource_name) { 'managed_san' }
  include_context 'chef context'

  it 'fails whe it does not exist' do
    allow_any_instance_of(OneviewSDK::ManagedSAN).to receive(:retrieve!).and_return(false)
    expect { real_chef_run }.to raise_error(RuntimeError, /not found/)
  end

  it 'sets public attributes if it is no alike' do
    allow_any_instance_of(OneviewSDK::ManagedSAN).to receive(:retrieve!).and_call_original
    allow(OneviewSDK::ManagedSAN).to receive(:find_by).and_return(
      [
        OneviewSDK::ManagedSAN.new(
          client,
          name: 'ManagedSAN1',
          publicAttributes: [
            {
              'name' => 'MetaSan',
              'value' => 'SAN',
              'valueType' => 'String',
              'valueFormat' => 'None'
            }
          ]
        )
      ]
    )
    expect_any_instance_of(OneviewSDK::ManagedSAN).to receive(:set_public_attributes).and_return(true)
    expect(real_chef_run).to set_oneview_managed_san_public_attributes('ManagedSAN1')
  end

  it 'does nothing when it exists and is alike' do
    allow_any_instance_of(OneviewSDK::ManagedSAN).to receive(:retrieve!).and_call_original
    allow(OneviewSDK::ManagedSAN).to receive(:find_by).and_return(
      [
        OneviewSDK::ManagedSAN.new(
          client,
          name: 'ManagedSAN1',
          publicAttributes: [
            {
              'name' => 'MetaSan',
              'value' => 'Neon SAN',
              'valueType' => 'String',
              'valueFormat' => 'None'
            }
          ]
        )
      ]
    )
    expect_any_instance_of(OneviewSDK::ManagedSAN).to_not receive(:set_public_attributes)
    expect(real_chef_run).to set_oneview_managed_san_public_attributes('ManagedSAN1')
  end
end
