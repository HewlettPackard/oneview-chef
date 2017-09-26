require_relative './../../spec_helper'
require_relative './../../fixtures/fake_resource'

RSpec.describe OneviewCookbook::ResourceProvider do
  include_context 'shared context'

  let(:res) { described_class.new(FakeResource.new) }

  before :each do
    allow(OneviewCookbook::Helper).to receive(:build_client).and_return @client
    allow(OneviewCookbook::Helper).to receive(:build_image_streamer_client).and_return @i3s_client
    @context = FakeResource.new
  end

  describe '#initialize' do
    it 'sets all the necessary resource info as instance variables' do
      r = described_class.new(@context)
      expect(r.context).to eq(@context)
      expect(r.resource_name).to eq(@context.resource_name)
      expect(r.name).to eq(@context.name)
      expect(r.sdk_resource_type).to eq('Resource')
      expect(r.sdk_api_version).to eq(nil)
      expect(r.sdk_variant).to eq(nil)
      expect(r.sdk_base_module).to eq(OneviewSDK)
      expect(r.item.client).to eq(@client)
      expect(r.item.data).to eq('name' => @context.name)
    end

    it "respects the resource's api_header_version property" do
      r = described_class.new(FakeResource.new(api_header_version: 2))
      expect(r.item.api_version).to eq(2)
    end

    it "respects the resource's data property" do
      data = { 'name' => 'myname', 'key' => 'val' }
      r = described_class.new(FakeResource.new(data: data))
      expect(r.item.data).to eq(data)
    end

    it 'builds valid API200 resources' do
      r = OneviewCookbook::API200::EthernetNetworkProvider.new(@context)
      expect(r.sdk_resource_type).to eq('EthernetNetwork')
      expect(r.sdk_api_version).to eq(200)
      expect(r.sdk_variant).to eq(nil)
      expect(r.item.class).to eq(OneviewSDK::API200::EthernetNetwork)
    end

    it 'builds valid API300::C7000 resources' do
      r = OneviewCookbook::API300::C7000::EthernetNetworkProvider.new(@context)
      expect(r.sdk_resource_type).to eq('EthernetNetwork')
      expect(r.sdk_api_version).to eq(300)
      expect(r.sdk_variant).to eq('C7000')
      expect(r.item.class).to eq(OneviewSDK::API300::C7000::EthernetNetwork)
    end

    it 'builds valid API300::Synergy resources' do
      r = OneviewCookbook::API300::Synergy::EthernetNetworkProvider.new(@context)
      expect(r.sdk_resource_type).to eq('EthernetNetwork')
      expect(r.sdk_api_version).to eq(300)
      expect(r.sdk_variant).to eq('Synergy')
      expect(r.item.class).to eq(OneviewSDK::API300::Synergy::EthernetNetwork)
    end

    it 'builds valid API500::C7000 resources' do
      r = OneviewCookbook::API500::C7000::ScopeProvider.new(@context)
      expect(r.sdk_resource_type).to eq('Scope')
      expect(r.sdk_api_version).to eq(500)
      expect(r.sdk_variant).to eq('C7000')
      expect(r.item.class).to eq(OneviewSDK::API500::C7000::Scope)
    end

    it 'builds valid API500::Synergy resources' do
      r = OneviewCookbook::API500::Synergy::ScopeProvider.new(@context)
      expect(r.sdk_resource_type).to eq('Scope')
      expect(r.sdk_api_version).to eq(500)
      expect(r.sdk_variant).to eq('Synergy')
      expect(r.item.class).to eq(OneviewSDK::API500::Synergy::Scope)
    end

    it 'builds valid ImageStreamer::API300 resources' do
      r = OneviewCookbook::ImageStreamer::API300::PlanScriptProvider.new(@context)
      expect(r.sdk_resource_type).to eq('PlanScript')
      expect(r.sdk_api_version).to eq(300)
      expect(r.sdk_variant).to eq(nil)
      expect(r.sdk_base_module).to eq(OneviewSDK::ImageStreamer)
      expect(r.item.class).to eq(OneviewSDK::ImageStreamer::API300::PlanScript)
    end

    it 'fails to build valid resource due to some unpredictable and catastrophicly wrong provider namespace' do
      module What
        module Are
          module You
            module Trying
              module To
                module Do
                  class CatastrophicProvider < OneviewCookbook::ResourceProvider
                  end
                end
              end
            end
          end
        end
      end
      expect { What::Are::You::Trying::To::Do::CatastrophicProvider.new(@context) }.to raise_error(NameError, /Can\'t build a resource object/)
    end
  end

  describe '#create_or_update' do
    before :each do
      expect(res).to receive(:save_res_info).and_return true
    end

    it 'creates the resource if it does not exist' do
      expect(res.item).to receive(:exists?).and_return(false)
      expect(res.item).to receive(:create).and_return(true)
      expect(Chef::Log).to receive(:info).with(/Create #{res.resource_name} '#{res.name}'/).twice.and_return true
      expect(res.create_or_update).to eq(true) # And returns true
    end

    it 'updates the resource if it exists but is not alike' do
      expect(res.item).to receive(:exists?).and_return(true)
      expect(res.item).to receive(:retrieve!).and_return(true)
      expect(res.item).to receive(:like?).and_return(false)
      expect(res.item).to receive(:update).and_return(true)
      expect(res).to receive(:get_diff).and_return('diff')
      expect(Chef::Log).to receive(:info).ordered.with("Update #{res.resource_name} '#{res.name}'diff").and_return true
      expect(Chef::Log).to receive(:info).ordered.with("Update #{res.resource_name} '#{res.name}'").and_return true
      expect(Chef::Log).to receive(:debug).with(/differs from OneView resource/).and_return true
      expect(Chef::Log).to receive(:debug)
        .with(/Current state: #{JSON.pretty_generate(res.item.data)}/).and_return true
      expect(Chef::Log).to receive(:debug).with(/Desired state/).and_return true
      expect(res.create_or_update).to eq(false) # And returns false
    end

    it 'does nothing if the resource exists and is alike' do
      expect(res.item).to receive(:exists?).and_return(true)
      expect(res.item).to receive(:retrieve!).and_return(true)
      expect(res.item).to receive(:like?).and_return(true)
      expect(Chef::Log).to receive(:info).with(/#{res.resource_name} '#{res.name}' is up to date/).and_return true
      expect(res.create_or_update).to eq(false) # And returns true
    end

    it 'accepts the method names as parameters' do
      expect(res.item).to receive(:exists?).and_return(false)
      expect(res.item).to receive(:method1).and_return(true)
      expect(Chef::Log).to receive(:info).with(/Method1 #{res.resource_name} '#{res.name}'/).twice.and_return true
      expect(res.create_or_update(:method1, :method2)).to eq(true) # And returns true
    end
  end

  describe '#add_or_edit' do
    it 'calls the create_or_update method with parameters' do
      expect(res).to receive(:create_or_update).with(:add, :edit)
      res.add_or_edit
    end
  end

  describe '#create_if_missing' do
    before :each do
      expect(res).to receive(:save_res_info).and_return true
    end

    it 'creates the resource if it does not exist' do
      expect(res.item).to receive(:exists?).and_return false
      expect(res.item).to receive(:create).and_return true
      expect(Chef::Log).to receive(:info).with(/Create #{res.resource_name} '#{res.name}'/).twice.and_return true
      expect(res.create_if_missing).to eq(true) # And returns true
    end

    it 'retrieves and saves the resource info if it already exists' do
      expect(res.item).to receive(:exists?).and_return(true)
      expect(res.item).to receive(:retrieve!).and_return(true)
      expect(Chef::Log).to receive(:info).with(/#{res.resource_name} '#{res.name}' exists/).and_return true
      expect(res.create_if_missing).to eq(false) # And returns false
    end

    it 'does not retrieve and save the resource info if it exists but save_resource_info is false' do
      res.context.save_resource_info = false
      expect(res.item).to receive(:exists?).and_return(true)
      expect(res.item).to_not receive(:retrieve!)
      expect(Chef::Log).to receive(:info).with(/#{res.resource_name} '#{res.name}' exists/).and_return true
      expect(res.create_if_missing).to eq(false) # And returns false
    end

    it 'accepts the method name as a parameter' do
      expect(res.item).to receive(:exists?).and_return false
      expect(res.item).to receive(:method1).and_return true
      expect(Chef::Log).to receive(:info).with(/Method1 #{res.resource_name} '#{res.name}'/).twice.and_return true
      expect(res.create_if_missing(:method1)).to eq(true) # And returns true
    end
  end

  describe '#add_if_missing' do
    it 'calls the create_if_missing method with parameters' do
      expect(res).to receive(:create_if_missing).with(:add)
      res.add_if_missing
    end
  end

  describe '#delete' do
    it 'returns false if the resource cannot be retrieved' do
      expect(res.item).to receive(:retrieve!).and_return(false)
      expect(res.delete).to eq(false)
    end

    it 'deletes the resource and returns true if it is sucessfully retrieved' do
      expect(res.item).to receive(:retrieve!).and_return(true)
      expect(res.item).to receive(:delete).and_return(true)
      expect(res.delete).to eq(true) # And returns true
    end
  end

  describe '#remove' do
    it 'calls the delete method with parameters' do
      expect(res).to receive(:delete).with(:remove)
      res.remove
    end
  end

  describe '#resource_named' do
    before :each do
      res.sdk_api_version = -1
      res.sdk_variant = '_variant_'
    end

    it 'calls the OneviewSDK::resource_named method with the default parameters' do
      expect(OneviewSDK).to receive(:resource_named).with(:ResourceType, -1, '_variant_')
      res.resource_named(:ResourceType)
    end

    it 'calls the OneviewSDK::resource_named method with overriden parameters' do
      expect(OneviewSDK).to receive(:resource_named).with(:ResourceType, -5, '_override_variant_')
      res.resource_named(:ResourceType, -5, '_override_variant_')
    end

    it 'calls the OneviewSDK::ImageStreamer::resource_named method' do
      expect(OneviewSDK::ImageStreamer).to receive(:resource_named).with(:ResourceType, -1, '_variant_')
      res.sdk_base_module = OneviewSDK::ImageStreamer
      res.resource_named(:ResourceType)
    end
  end

  describe '#patch' do
    it 'perform patch with operation, path and value' do
      allow(res.context).to receive(:operation).and_return('OP')
      allow(res.context).to receive(:path).and_return('PH')
      allow(res.context).to receive(:value).and_return('VA')
      allow(res.item).to receive(:retrieve!).and_return(true)
      expect(res.item).to receive(:patch).with('OP', 'PH', 'VA').and_return(true)
      res.patch
    end

    it 'perform patch with operation and path but no value' do
      allow(res.context).to receive(:operation).and_return('OP')
      allow(res.context).to receive(:path).and_return('PH')
      allow(res.context).to receive(:value).and_return(nil)
      allow(res.item).to receive(:retrieve!).and_return(true)
      expect(res.item).to receive(:patch).with('OP', 'PH', nil).and_return(true)
      res.patch
    end

    it 'does not perform patch without operation' do
      allow(res.context).to receive(:operation).and_return(nil)
      allow(res.context).to receive(:path).and_return('PH')
      allow(res.context).to receive(:value).and_return('VA')
      allow(res.item).to receive(:retrieve!).and_return(true)
      expect(res.item).to_not receive(:patch)
      expect { res.patch }.to raise_error(/InvalidParameters: Parameters .+ must be set for patch/)
    end

    it 'does not perform patch without path' do
      allow(res.context).to receive(:operation).and_return('OP')
      allow(res.context).to receive(:path).and_return(nil)
      allow(res.context).to receive(:value).and_return('VA')
      allow(res.item).to receive(:retrieve!).and_return(true)
      expect(res.item).to_not receive(:patch)
      expect { res.patch }.to raise_error(/InvalidParameters: Parameters .+ must be set for patch/)
    end

    it 'does not perform patch if resource does not exists' do
      allow(res.context).to receive(:operation).and_return('OP')
      allow(res.context).to receive(:path).and_return('PH')
      allow(res.context).to receive(:value).and_return('VA')
      allow(res.item).to receive(:retrieve!).and_return(false)
      expect(res.item).to_not receive(:patch)
      expect { res.patch }.to raise_error(/ResourceNotFound: Patch failed/)
    end
  end

  describe '#add_to_scopes' do
    let(:scope1) { OneviewSDK::API300::Synergy::Scope.new(@client, name: 'Scope1', uri: '/rest/fake/1') }
    let(:scope2) { OneviewSDK::API300::Synergy::Scope.new(@client, name: 'Scope1', uri: '/rest/fake/2') }

    before do
      expect(res.item).to receive(:retrieve!).and_return(true)
      allow(res.context.new_resource).to receive(:scopes).and_return(['Scope1', 'Scope2'])
      allow(res).to receive(:load_resource).with(:Scope, 'Scope1').and_return(scope1)
      allow(res).to receive(:load_resource).with(:Scope, 'Scope2').and_return(scope2)
    end

    it 'should call add_to_scopes method from Oneview resource if scope is not already added' do
      allow(res.item).to receive(:[]).with('scopeUris').and_return([])
      expect(res.item).to receive(:add_scope).with(scope1)
      expect(res.item).to receive(:add_scope).with(scope2)
      res.send(:add_to_scopes)
    end

    it 'should call add_to_scopes method from Oneview resource if one of scopes is not already added' do
      allow(res.item).to receive(:[]).with('scopeUris').and_return(['/rest/fake/1'])
      expect(res.item).not_to receive(:add_scope).with(scope1)
      expect(res.item).to receive(:add_scope).with(scope2)
      res.send(:add_to_scopes)
    end

    it 'should not call add_to_scopes method from Oneview resource if all scopes are already added' do
      allow(res.item).to receive(:[]).with('scopeUris').and_return(['/rest/fake/1', '/rest/fake/2'])
      expect(res.item).not_to receive(:add_scope)
      res.send(:add_to_scopes)
    end
  end

  describe '#remove_from_scopes' do
    let(:scope1) { OneviewSDK::API300::Synergy::Scope.new(@client, name: 'Scope1', uri: '/rest/fake/1') }
    let(:scope2) { OneviewSDK::API300::Synergy::Scope.new(@client, name: 'Scope1', uri: '/rest/fake/2') }

    before do
      allow(res.item).to receive(:retrieve!).and_return(true)
      allow(res.context.new_resource).to receive(:scopes).and_return(['Scope1', 'Scope2'])
      allow(res).to receive(:load_resource).with(:Scope, 'Scope1').and_return(scope1)
      allow(res).to receive(:load_resource).with(:Scope, 'Scope2').and_return(scope2)
    end

    it 'should call remove_from_scopes method from Oneview resource if scopes are not already removed' do
      allow(res.item).to receive(:[]).with('scopeUris').and_return(['/rest/fake/1', '/rest/fake/2'])
      expect(res.item).to receive(:remove_scope).with(scope1)
      expect(res.item).to receive(:remove_scope).with(scope2)
      res.send(:remove_from_scopes)
    end

    it 'should call remove_from_scopes method from Oneview resource if at least one of scopes is not already removed' do
      allow(res.item).to receive(:[]).with('scopeUris').and_return(['/rest/fake/2'])
      expect(res.item).not_to receive(:remove_scope).with(scope1)
      expect(res.item).to receive(:remove_scope).with(scope2)
      res.send(:remove_from_scopes)
    end

    it 'should not call remove_from_scopes method from Oneview resource if all scopes are already removed' do
      allow(res.item).to receive(:[]).with('scopeUris').and_return([])
      expect(res.item).not_to receive(:remove_scope)
      res.send(:remove_from_scopes)
    end
  end

  describe '#replace_scopes' do
    let(:scope1) { OneviewSDK::API300::Synergy::Scope.new(@client, name: 'Scope1', uri: '/rest/fake/1') }
    let(:scope2) { OneviewSDK::API300::Synergy::Scope.new(@client, name: 'Scope2', uri: '/rest/fake/2') }

    before do
      allow(res.item).to receive(:retrieve!).and_return(true)
      allow(res.context.new_resource).to receive(:scopes).and_return(['Scope1', 'Scope2'])
      allow(res).to receive(:load_resource).with(:Scope, 'Scope1').and_return(scope1)
      allow(res).to receive(:load_resource).with(:Scope, 'Scope2').and_return(scope2)
    end

    it 'should call replace_scopes method from Oneview resource if scope is not already replaced' do
      allow(res.item).to receive(:[]).with('scopeUris').and_return([])
      expect(res.item).to receive(:replace_scopes).with([scope1, scope2])
      res.send(:replace_scopes)
    end

    it 'should call replace_scopes method from Oneview resource if one of scopes is not already added' do
      allow(res.item).to receive(:[]).with('scopeUris').and_return(['/rest/fake/2'])
      expect(res.item).to receive(:replace_scopes).with([scope1, scope2])
      res.send(:replace_scopes)
    end

    it 'should not call replace_scopes method from Oneview resource if all scopes are already replaced' do
      allow(res.item).to receive(:[]).with('scopeUris').and_return(['/rest/fake/2', '/rest/fake/1'])
      expect(res.item).not_to receive(:replace_scopes)
      res.send(:replace_scopes)
    end
  end

  describe '#save_res_info' do
    before :each do
      res.item.data['uri'] = '/rest/fake'
      res.item.data['status'] = 'OK'
    end

    it 'saves everything when save_resource_info is set to true' do
      res.context.save_resource_info = true
      res.send(:save_res_info)
      expect(res.context.node['oneview'][@client.url][res.name]).to eq(res.item.data)
    end

    it 'can save a subset of values' do
      res.context.save_resource_info = ['uri', 'name']
      res.send(:save_res_info)
      expect(res.context.node['oneview'][@client.url][res.name]).to eq('uri' => '/rest/fake', 'name' => res.name)
    end

    it 'saves nothing when save_resource_info is set to false' do
      res.context.save_resource_info = false
      res.context.node.default['oneview'][@client.url] ||= {}
      res.send(:save_res_info)
      expect(res.context.node['oneview'][@client.url][res.name]).to eq(nil)
    end

    it 'prints to the Chef error log when it fails to save the data' do
      expect(Chef::Log).to receive(:error).with(/Failed to save resource data/)
      res.context.node = nil
      res.send(:save_res_info)
    end
  end

  describe '#convert_keys' do
    it 'calls the Helper method' do
      expect(OneviewCookbook::Helper).to receive(:convert_keys)
        .with(:info, :conversion_method).and_return(:value)
      expect(res.send(:convert_keys, :info, :conversion_method)).to eq(:value)
    end
  end

  describe '#get_diff' do
    it 'calls the Helper method' do
      expect(OneviewCookbook::Helper).to receive(:get_diff)
        .with(:resource, :desired_data).and_return(:value)
      expect(res.send(:get_diff, :resource, :desired_data)).to eq('. Diff: value')
    end

    it 'converts empty diffs' do
      expect(OneviewCookbook::Helper).to receive(:get_diff)
        .with(:resource, :desired_data).and_return('')
      expect(res.send(:get_diff, :resource, :desired_data)).to eq('. (no diff)')
    end
  end

  describe '#recursive_diff' do
    it 'calls the Helper method' do
      expect(OneviewCookbook::Helper).to receive(:recursive_diff)
        .with(:data, :desired_data, :str, :indent).and_return(:value)
      expect(res.send(:recursive_diff, :data, :desired_data, :str, :indent)).to eq(:value)
    end

    it 'has defaults for str & indent' do
      expect(OneviewCookbook::Helper).to receive(:recursive_diff)
        .with(:data, :desired_data, '', '').and_return(:value)
      expect(res.send(:recursive_diff, :data, :desired_data)).to eq(:value)
    end
  end

  describe '#load_resource' do
    let(:sdk_klass) { OneviewSDK::API200::VolumeTemplate }
    let(:sdk_klass2) { OneviewSDK::ImageStreamer::API300::GoldenImage }

    before :each do
      @res = OneviewCookbook::API200::VolumeProvider.new(@context)
      @other_res = sdk_klass.new(@client, name: 'T1', description: 'Blah', uri: '/fake')
    end

    it 'retrieves a resource successfully when it exists (default by name)' do
      expect(sdk_klass).to receive(:find_by).and_return([@other_res])
      r = @res.load_resource(:VolumeTemplate, 'T1')
      expect(r).to be_a(sdk_klass)
      expect(r.data).to eq(@other_res.data)
    end

    it 'retrieves a resource successfully when it exists (by data Hash)' do
      expect(sdk_klass).to receive(:find_by).and_return([@other_res])
      r = @res.load_resource(:VolumeTemplate, uri: '/fake')
      expect(r).to be_a(sdk_klass)
      expect(r.data).to eq(@other_res.data)
    end

    it 'retrieves image streamer resources when they exist' do
      res = OneviewCookbook::ImageStreamer::API300::DeploymentPlanProvider.new(@context)
      g_image = sdk_klass2.new(@client, name: 'I1', description: 'Image')
      expect(sdk_klass2).to receive(:find_by).and_return([g_image])
      r = res.load_resource(:GoldenImage, 'I1')
      expect(r).to be_a(sdk_klass2)
      expect(r.data).to eq(g_image.data)
    end

    it 'fails when the resource does not exist' do
      expect_any_instance_of(sdk_klass).to receive(:retrieve!).and_return(false)
      expect { @res.load_resource(:VolumeTemplate, 'T2') }.to raise_error(OneviewSDK::NotFound, /not found/)
    end

    it 'returns a resource attribute when called with the ret_attribute' do
      expect(sdk_klass).to receive(:find_by).and_return([@other_res])
      r = @res.load_resource(:VolumeTemplate, 'T1', :uri)
      expect(r).to eq('/fake')
    end
  end

  describe '#validates_presence_of' do
    it 'should not throw error when propeties are set' do
      expect(res.context.new_resource).to receive(:storage_system).and_return('some value')
      expect(res.context.new_resource).to receive(:storage_pool).and_return('some value')
      expect { res.validate_required_properties(:storage_system, :storage_pool) }.not_to raise_error
    end

    it 'should throw error when propeties are not set' do
      expect(res.context.new_resource).to receive(:storage_system).and_return('some value')
      expect(res.context.new_resource).to receive(:storage_pool).and_return(nil)
      expect { res.validate_required_properties(:storage_system, :storage_pool) }.to raise_error(/Unspecified property: 'storage_pool'./)
    end
  end
end
