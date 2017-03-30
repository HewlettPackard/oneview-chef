require_relative './../../../spec_helper'

describe 'oneview_test::server_profile_create_from_template' do
  let(:resource_name) { 'server_profile' }
  include_context 'chef context'

  let(:klass) { OneviewSDK::ServerProfile }
  let(:template1) do
    OneviewSDK::ServerProfileTemplate.new(client, name: 'Template1', uri: '/template1', description: 'Blah', serverProfileDescription: 'Other')
  end
  let(:new_profile) do
    klass.new(client, name: 'ServerProfile1', uri: nil, description: 'Other', serverProfileTemplateUri: '/template1')
  end

  it 'creates it using the template when it does not exist' do
    expect_any_instance_of(OneviewSDK::ServerProfile).to receive(:exists?).and_return(false)
    expect(OneviewSDK::ServerProfileTemplate).to receive(:find_by).and_return([template1])
    expect_any_instance_of(OneviewSDK::ServerProfileTemplate).to receive(:new_profile)
      .with('ServerProfile1').and_return(new_profile)
    expect_any_instance_of(OneviewSDK::ServerProfile).to receive(:create) do |r|
      expect(r['description']).to eq('Something') # Proves data property overrides the template
      expect(r['serverProfileTemplateUri']).to eq('/template1') # But non-overriden template values remain
      true
    end
    expect(real_chef_run).to create_oneview_server_profile('ServerProfile1')
  end

  it 'requires a valid template name' do
    expect_any_instance_of(OneviewSDK::ServerProfile).to receive(:exists?).and_return(false)
    expect(OneviewSDK::ServerProfileTemplate).to receive(:find_by).and_return([])
    expect { real_chef_run }.to raise_error(OneviewSDK::NotFound, /not found/)
  end
end
