require_relative './../../../spec_helper'

describe 'oneview_test::logical_enclosure_create_if_missing' do
  let(:resource_name) { 'logical_enclosure' }
  let(:klass) { OneviewSDK::LogicalEnclosure }
  include_context 'chef context'

  before :each do
    allow(OneviewSDK::EnclosureGroup).to receive(:find_by).with(instance_of(OneviewSDK::Client), name: 'EG1')
      .and_return([{ 'uri' => '/rest/fake' }])
    allow(OneviewSDK::Enclosure).to receive(:find_by).at_most(2).times
      .and_return([OneviewSDK::Enclosure.new(client, uri: '/rest/fake')])
  end

  it 'creates it when it does not exist' do
    expect_any_instance_of(klass).to receive(:exists?).and_return(false)
    expect_any_instance_of(klass).to receive(:create).and_return(true)
    expect(real_chef_run).to create_oneview_logical_enclosure_if_missing('LogicalEnclosure1')
  end

  it 'does nothing when it exists' do
    expect_any_instance_of(klass).to receive(:exists?).and_return(true)
    expect_any_instance_of(klass).to_not receive(:create)
    expect_any_instance_of(klass).to receive(:retrieve!).and_return(true)
    expect(real_chef_run).to create_oneview_logical_enclosure_if_missing('LogicalEnclosure1')
  end
end
