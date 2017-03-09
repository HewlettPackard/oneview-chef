require_relative './../../../spec_helper'

describe 'oneview_test::logical_interconnect_add_interconnect' do
  let(:resource_name) { 'logical_interconnect' }
  include_context 'chef context'
  include_context 'shared context'

  let(:klass) { OneviewSDK::LogicalInterconnect }
  let(:provider) { OneviewCookbook::API200::LogicalInterconnectProvider }
  let(:enclosure) { OneviewSDK::Enclosure.new(@client, name: 'EnclU', uri: '/rest/enclosure/fake') }
  let(:interconnect) { OneviewSDK::Interconnect.new(@client, name: 'IntercU', uri: '/rest/interconnect/fake') }
  let(:location_entries) do
    {
      'locationEntries' => [
        { 'type' => 'Bay', 'value' => '1' },
        { 'type' => 'Enclosure', 'value' => '/rest/enclosure/fake' }
      ]
    }
  end

  it 'adds one interconnect when there is no interconnect' do
    allow(OneviewSDK::Interconnect).to receive(:get_all).and_return([])
    allow_any_instance_of(provider).to receive(:load_resource).with(:Enclosure, anything).and_return(enclosure)
    expect_any_instance_of(klass).to receive(:create).with(1, enclosure).and_return(true)
    expect(real_chef_run).to add_oneview_logical_interconnect_interconnect('LogicalInterconnect-add')
  end

  it 'adds when the interconnect exists, but it is absent' do
    interconnect['interconnectLocation'] = location_entries
    interconnect['state'] = 'Absent'
    allow(OneviewSDK::Interconnect).to receive(:get_all).and_return([interconnect])
    allow_any_instance_of(provider).to receive(:load_resource).with(:Enclosure, anything).and_return(enclosure)
    expect_any_instance_of(klass).to receive(:create).with(1, enclosure).and_return(true)
    expect(real_chef_run).to add_oneview_logical_interconnect_interconnect('LogicalInterconnect-add')
  end

  it 'does nothing when it already exists and it is managed' do
    interconnect['interconnectLocation'] = location_entries
    interconnect['state'] = 'Configured'
    allow(OneviewSDK::Interconnect).to receive(:get_all).and_return([interconnect])
    allow_any_instance_of(provider).to receive(:load_resource).with(:Enclosure, anything).and_return(enclosure)
    expect_any_instance_of(klass).to_not receive(:create).with(1, enclosure)
    expect(real_chef_run).to add_oneview_logical_interconnect_interconnect('LogicalInterconnect-add')
  end
end
