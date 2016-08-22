require_relative './../../../spec_helper'

describe 'oneview_test::logical_enclosure_reconfigure' do
  let(:resource_name) { 'logical_enclosure' }
  include_context 'chef context'

  let(:fake_client) { OneviewSDK::Client.new(url: 'https://oneview.example.com', user: 'Administrator', password: 'secret123') }

  let(:encl1) do
    OneviewSDK::Enclosure.new(
      fake_client,
      name: 'encl1',
      reconfigurationState: 'Pending',
      uri: '/rest/enclosures/encl1'
    )
  end

  let(:encl2) do
    OneviewSDK::Enclosure.new(
      fake_client,
      name: 'encl2',
      reconfigurationState: 'NotReapplyingConfiguration',
      uri: '/rest/enclosures/encl2'
    )
  end

  before :each do
    allow_any_instance_of(OneviewSDK::LogicalEnclosure).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::LogicalEnclosure).to receive(:[]).with('enclosureUris')
      .and_return(['/rest/enclosures/encl1', '/rest/enclosures/encl2'])
    allow_any_instance_of(OneviewSDK::LogicalEnclosure).to receive(:[]).with('name').and_call_original
    allow(OneviewSDK::Enclosure).to receive(:find_by).with(instance_of(OneviewSDK::Client), uri: '/rest/enclosures/encl1')
      .and_return([encl1])
    allow(OneviewSDK::Enclosure).to receive(:find_by).with(instance_of(OneviewSDK::Client), uri: '/rest/enclosures/encl2')
      .and_return([encl2])
  end

  it 'reconfigures when an enclosure state is "NotReapplyingConfiguration"' do
    expect_any_instance_of(OneviewSDK::LogicalEnclosure).to receive(:reconfigure).and_return(true)
    expect(real_chef_run).to reconfigure_oneview_logical_enclosure('LogicalEnclosure1')
  end

  it 'reconfigures when an enclosure state is "ReapplyingConfigurationFailed"' do
    encl2[:reconfigurationState] = 'ReapplyingConfigurationFailed'
    expect_any_instance_of(OneviewSDK::LogicalEnclosure).to receive(:reconfigure).and_return(true)
    expect(real_chef_run).to reconfigure_oneview_logical_enclosure('LogicalEnclosure1')
  end

  it 'reconfigures when an enclosure state is ""' do
    encl2[:reconfigurationState] = ''
    expect_any_instance_of(OneviewSDK::LogicalEnclosure).to receive(:reconfigure).and_return(true)
    expect(real_chef_run).to reconfigure_oneview_logical_enclosure('LogicalEnclosure1')
  end

  it 'does not reconfigure when the enclosure states are "Pending"' do
    encl2[:reconfigurationState] = 'Pending'
    expect_any_instance_of(OneviewSDK::LogicalEnclosure).to_not receive(:reconfigure)
    expect(real_chef_run).to reconfigure_oneview_logical_enclosure('LogicalEnclosure1')
  end
end
