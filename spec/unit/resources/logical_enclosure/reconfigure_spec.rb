require_relative './../../../spec_helper'

describe 'oneview_test::logical_enclosure_reconfigure' do
  let(:resource_name) { 'logical_enclosure' }
  include_context 'chef context'
  include_context 'shared context'

  it 'reconfigure logical enclosure not triggered' do
    enclosure_uris = ['/rest/enclosures/encl1', '/rest/enclosures/encl2']
    encl1 = OneviewSDK::Enclosure.new(
      @client,
      name: 'encl1',
      reconfigurationState: 'Pending',
      uri: '/rest/enclosures/encl1'
    )
    encl2 = OneviewSDK::Enclosure.new(
      @client,
      name: 'encl2',
      reconfigurationState: 'NotReapplyingConfiguration',
      uri: '/rest/enclosures/encl2'
    )
    allow(OneviewSDK::Enclosure).to receive(:find_by).with(instance_of(OneviewSDK::Client), uri: '/rest/enclosures/encl1')
      .and_return([encl1])
    allow(OneviewSDK::Enclosure).to receive(:find_by).with(instance_of(OneviewSDK::Client), uri: '/rest/enclosures/encl2')
      .and_return([encl2])

    allow_any_instance_of(OneviewSDK::LogicalEnclosure).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::LogicalEnclosure).to receive(:[]).with('enclosureUris')
      .and_return(enclosure_uris)
    allow_any_instance_of(OneviewSDK::LogicalEnclosure).to receive(:[]).with('name')
      .and_return('LogicalEnclosure1')
    expect_any_instance_of(OneviewSDK::LogicalEnclosure).to receive(:reconfigure).and_return(true)
    expect(real_chef_run).to reconfigure_oneview_logical_enclosure('LogicalEnclosure1')
  end

  it 'reconfigure logical enclosure should not be triggered' do
    enclosure_uris = ['/rest/enclosures/encl1', '/rest/enclosures/encl2']
    encl1 = OneviewSDK::Enclosure.new(
      @client,
      name: 'encl1',
      reconfigurationState: 'Pending',
      uri: '/rest/enclosures/encl1'
    )
    encl2 = OneviewSDK::Enclosure.new(
      @client,
      name: 'encl2',
      reconfigurationState: 'Pending',
      uri: '/rest/enclosures/encl2'
    )
    allow(OneviewSDK::Enclosure).to receive(:find_by).with(instance_of(OneviewSDK::Client), uri: '/rest/enclosures/encl1')
      .and_return([encl1])
    allow(OneviewSDK::Enclosure).to receive(:find_by).with(instance_of(OneviewSDK::Client), uri: '/rest/enclosures/encl2')
      .and_return([encl2])
    allow_any_instance_of(OneviewSDK::LogicalEnclosure).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::LogicalEnclosure).to receive(:[]).with('enclosureUris')
      .and_return(enclosure_uris)
    allow_any_instance_of(OneviewSDK::LogicalEnclosure).to receive(:[]).with('name')
      .and_return('LogicalEnclosure1')
    expect_any_instance_of(OneviewSDK::LogicalEnclosure).to_not receive(:reconfigure)
    expect(real_chef_run).to reconfigure_oneview_logical_enclosure('LogicalEnclosure1')
  end
end
