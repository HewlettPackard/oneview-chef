require_relative './../../../spec_helper'

describe 'oneview_test::logical_enclosure_create' do
  let(:resource_name) { 'logical_enclosure' }
  let(:klass) { OneviewSDK::LogicalEnclosure }
  include_context 'chef context'
  let(:provider) { OneviewCookbook::API200::LogicalEnclosureProvider }

  before :each do
    allow_any_instance_of(provider).to receive(:load_resource).and_call_original
    allow_any_instance_of(provider).to receive(:load_resource)
      .with(:EnclosureGroup, anything, 'uri').and_return('/rest/fake')
    allow_any_instance_of(provider).to receive(:load_resource)
      .with(:Enclosure, anything, 'uri').and_return('/rest/fake')
  end

  before :each do
    allow(OneviewSDK::EnclosureGroup).to receive(:find_by).with(instance_of(OneviewSDK::Client), name: 'EG1')
                                                          .and_return([{ 'uri' => '/rest/fake' }])
    allow(OneviewSDK::Enclosure).to receive(:find_by).at_most(2).times
                                                     .and_return([OneviewSDK::Enclosure.new(client, uri: '/rest/fake')])
  end

  it 'creates it when it does not exist' do
    expect_any_instance_of(klass).to receive(:exists?).and_return(false)
    expect_any_instance_of(klass).to receive(:create).and_return(true)
    expect(real_chef_run).to create_oneview_logical_enclosure('LogicalEnclosure1')
  end

  it 'updates it when it exists but not alike' do
    expect_any_instance_of(klass).to receive(:exists?).and_return(true)
    expect_any_instance_of(klass).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(klass).to receive(:like?).and_return(false)
    expect_any_instance_of(klass).to receive(:update).and_return(true)
    expect(real_chef_run).to create_oneview_logical_enclosure('LogicalEnclosure1')
  end

  it 'does nothing when it exists and is alike' do
    expect_any_instance_of(klass).to receive(:exists?).and_return(true)
    expect_any_instance_of(klass).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(klass).to receive(:like?).and_return(true)
    expect_any_instance_of(klass).to_not receive(:update).and_return(true)
    expect_any_instance_of(klass).to_not receive(:create).and_return(true)
    expect(real_chef_run).to create_oneview_logical_enclosure('LogicalEnclosure1')
  end
end
