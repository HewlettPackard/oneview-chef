require_relative './../../spec_helper'
require_relative './../../fixtures/fake_resource'
require 'chef/node'

RSpec.describe OneviewCookbook::Helper do
  include_context 'shared context'

  let(:helper) do
    (Class.new { include OneviewCookbook::Helper }).new
  end

  let(:sdk_version) { '~> 2.1' }

  let(:resource_type) { :EthernetNetwork }

  describe '::get_provider_named' do
    it 'should return provider correclty' do
      result = described_class.get_provider_named(:EthernetNetwork, OneviewCookbook::API300, :C7000)
      expect(result).to be(OneviewCookbook::API300::C7000::EthernetNetworkProvider)
    end

    it 'should raise error when variant is not supported' do
      expect { described_class.get_provider_named(:EthernetNetwork, OneviewCookbook::API300, :Wrong) }
        .to raise_error(RuntimeError, /API300 variant Wrong is not supported!/)
    end

    it 'should raise error when type not exist' do
      expect { described_class.get_provider_named(:EthernetNetworkWrong, OneviewCookbook::API300, :C7000) }
        .to raise_error(RuntimeError, /The 'EthernetNetworkWrong' resource does not exist for OneView API300, variant C7000/)
    end
  end

  describe '::do_resource_action' do
    it 'calls all the other methods with the correct parameters' do
      context = FakeResource.new
      fake_class = Class.new
      fake_res = 'fake'
      expect(described_class).to receive(:get_resource_class).with(context, resource_type, OneviewCookbook)
                                                             .and_return(fake_class)
      expect(fake_class).to receive(:new).with(context).and_return(fake_res)
      expect(fake_res).to receive(:send).with(:delete).and_return(true)
      expect(described_class.do_resource_action(context, resource_type, :delete)).to eq(true)
    end
  end

  describe '::get_resource_class' do
    before :each do
      allow(described_class).to receive(:load_sdk).with(kind_of(FakeResource)).and_return(true)
    end

    it 'uses the node attributes as defaults' do
      context = FakeResource.new
      klass = described_class.get_resource_class(context, resource_type)
      expect(klass).to eq(OneviewCookbook::API200::EthernetNetworkProvider)
    end

    it "respects the resource's api_version property" do
      context = FakeResource.new(api_version: 300)
      klass = described_class.get_resource_class(context, resource_type)
      expect(klass).to eq(OneviewCookbook::API300::C7000::EthernetNetworkProvider)
    end

    it "respects the resource's api_variant property" do
      context = FakeResource.new(api_version: 300, api_variant: :Synergy)
      klass = described_class.get_resource_class(context, resource_type)
      expect(klass).to eq(OneviewCookbook::API300::Synergy::EthernetNetworkProvider)
    end

    it "respects the client's api_version parameter when the client is a Hash" do
      context = FakeResource.new(client: { api_version: 300 })
      klass = described_class.get_resource_class(context, resource_type)
      expect(klass).to eq(OneviewCookbook::API300::C7000::EthernetNetworkProvider)
    end

    it "respects the client's api_version parameter when the client is a OneviewSDK::Client" do
      fake_client = Object.new
      allow(fake_client).to receive(:is_a?).with(Hash).and_return(false)
      allow(fake_client).to receive(:is_a?).with(OneviewSDK::Client).and_return(true)
      allow(fake_client).to receive(:api_version).and_return(300)
      context = FakeResource.new(client: fake_client)
      klass = described_class.get_resource_class(context, resource_type)
      expect(klass).to eq(OneviewCookbook::API300::C7000::EthernetNetworkProvider)
    end
  end

  describe '::get_api_module' do
    it 'gets the module for valid api versions' do
      [200, 300].each do |version|
        klass = described_class.get_api_module(version)
        expect(klass.to_s).to eq("OneviewCookbook::API#{version}")
      end
    end

    it 'gets the module for a valid api version with a different base module' do
      klass = described_class.get_api_module(300, OneviewCookbook::ImageStreamer)
      expect(klass).to eq(OneviewCookbook::ImageStreamer::API300)
    end

    it 'fails if the version is invalid' do
      expect { described_class.get_api_module(2) }
        .to raise_error(/api_version 2 is not supported/)
    end
  end

  describe '::load_sdk' do
    before :each do
      @context = FakeResource.new(node: { 'oneview' => { 'ruby_sdk_version' => sdk_version } })
    end

    it 'loads the specified version of the gem' do
      expect(described_class).to receive(:gem).with('oneview-sdk', sdk_version)
      described_class.load_sdk(@context)
    end

    it 'attempts to install the gem if it is not found' do
      expect(described_class).to receive(:gem).once.and_raise LoadError
      expect(described_class).to receive(:gem).once.and_return true

      # Mocks @context.chef_gem
      expect(@context).to receive(:chef_gem).with('oneview-sdk').and_yield
      expect(described_class).to receive(:version).with(sdk_version).and_return(true)
      expect(described_class).to receive(:compile_time).with(true).and_return(true)

      expect(described_class).to receive(:require).with('oneview-sdk').and_return true
      described_class.load_sdk(@context)
    end

    it 'prints an error message if the gem cannot be loaded either time' do
      expect(described_class).to receive(:gem).twice.and_raise LoadError, 'Blah'
      expect(Chef::Log).to receive(:error).with(/cannot be loaded. Message: Blah/)
      expect(Chef::Log).to receive(:error).with(/Loaded version .* instead/)
      expect(@context).to receive(:chef_gem).with('oneview-sdk').and_return true
      expect(described_class).to receive(:require).with('oneview-sdk').and_return true
      described_class.load_sdk(@context)
    end
  end

  describe '::build_client' do
    it 'requires a valid oneview object' do
      expect { described_class.build_client(1) }.to raise_error(/Invalid client .* OneviewSDK::Client/)
      expect { described_class.build_client(nil) }.to raise_error(OneviewSDK::InvalidClient, /Must set/)
    end

    it 'supports using OneviewSDK user/password environment variables' do
      ENV['ONEVIEWSDK_URL'] = @ov_options[:url]
      ENV['ONEVIEWSDK_USER'] = @ov_options[:user]
      ENV['ONEVIEWSDK_PASSWORD'] = @ov_options[:password]
      ov = described_class.build_client
      expect(ov.url).to eq(@ov_options[:url])
      expect(ov.user).to eq(@ov_options[:user])
      expect(ov.password).to eq(@ov_options[:password])
    end

    it 'supports using OneviewSDK token/ssl environment variables' do
      ENV['ONEVIEWSDK_URL'] = @ov_options[:url]
      ENV['ONEVIEWSDK_TOKEN'] = 'faketoken'
      ENV['ONEVIEWSDK_SSL_ENABLED'] = 'false'
      ov = described_class.build_client
      expect(ov.url).to eq(@ov_options[:url])
      expect(ov.token).to eq('faketoken')
      expect(ov.ssl_enabled).to eq(false)
    end

    it 'accepts an OneviewSDK::Client object' do
      ov = described_class.build_client(@client)
      expect(ov).to eq(@client)
    end

    it 'accepts a hash' do
      ov = described_class.build_client(@ov_options)
      expect(ov.url).to eq(@ov_options[:url])
      expect(ov.user).to eq(@ov_options[:user])
      expect(ov.password).to eq(@ov_options[:password])
    end

    it 'defaults the log level to what Chef is using' do
      ov = described_class.build_client(@ov_options)
      expect(ov.log_level).to eq(Chef::Log.level)
    end

    it 'defaults to the Chef logger and log level' do
      ov = described_class.build_client(@ov_options)
      expect(ov.logger).to eq(Chef::Log)
      expect(ov.log_level).to eq(Chef::Log.level)
    end

    it "doesn't allow the log level to be overridden when no logger is specified" do
      level = Chef::Log.level == :warn ? :info : :warn
      ov = described_class.build_client(@ov_options.merge(log_level: level))
      expect(ov.log_level).to_not eq(level)
      expect(ov.log_level).to eq(Chef::Log.level)
    end

    it 'allows the log level to be overridden if the logger is specified' do
      level = Chef::Log.level == :warn ? :info : :warn
      ov = described_class.build_client(@ov_options.merge(logger: Logger.new(STDOUT), log_level: level))
      expect(ov.log_level).to eq(level)
      expect(ov.log_level).to_not eq(Chef::Log.level)
    end
  end

  describe '::build_image_streamer_client' do
    it 'requires a valid oneview object' do
      expect { described_class.build_image_streamer_client('bananas') }.to raise_error(/Invalid client .* OneviewSDK::ImageStreamer::Client/)
      expect { described_class.build_image_streamer_client(nil) }.to raise_error(OneviewSDK::InvalidClient, /Must set/)
    end

    it 'supports using Image Streamer url & token environment variables' do
      ENV['I3S_URL'] = @i3s_options[:url]
      ENV['ONEVIEWSDK_TOKEN'] = @i3s_options[:token]
      i3s_client = described_class.build_image_streamer_client
      expect(i3s_client.url).to eq(@i3s_options[:url])
      expect(i3s_client.token).to eq(@i3s_options[:token])
    end

    it 'accepts an OneviewSDK::Client object' do
      i3s = described_class.build_image_streamer_client(@i3s_client)
      expect(i3s).to eq(@i3s_client)
    end

    it 'accepts a hash with the token defined' do
      i3s = described_class.build_image_streamer_client(@i3s_options)
      expect(i3s.url).to eq(@i3s_options[:url])
      expect(i3s.token).to eq(@i3s_options[:token])
    end

    it 'accepts a hash with the oneview client defined' do
      expect(described_class).to receive(:build_client).with(@client).and_return(@client)
      i3s = described_class.build_image_streamer_client(@i3s_options.merge(oneview_client: @client))
      expect(i3s.url).to eq(@i3s_options[:url])
      expect(i3s.token).to eq('secretToken')
    end

    it 'defaults the log level to what Chef is using' do
      i3s = described_class.build_image_streamer_client(@i3s_options)
      expect(i3s.log_level).to eq(Chef::Log.level)
    end

    it 'defaults to the Chef logger and log level' do
      i3s = described_class.build_image_streamer_client(@i3s_options)
      expect(i3s.logger).to eq(Chef::Log)
      expect(i3s.log_level).to eq(Chef::Log.level)
    end

    it "doesn't allow the log level to be overridden when no logger is specified" do
      level = Chef::Log.level == :warn ? :info : :warn
      i3s = described_class.build_image_streamer_client(@i3s_options.merge(log_level: level))
      expect(i3s.log_level).to_not eq(level)
      expect(i3s.log_level).to eq(Chef::Log.level)
    end

    it 'allows the log level to be overridden if the logger is specified' do
      level = Chef::Log.level == :warn ? :info : :warn
      i3s = described_class.build_image_streamer_client(@i3s_options.merge(logger: Logger.new(STDOUT), log_level: level))
      expect(i3s.log_level).to eq(level)
      expect(i3s.log_level).to_not eq(Chef::Log.level)
    end
  end

  describe '::convert_keys' do
    it 'converts simple hash keys' do
      simple1 = { a: 1, b: 2, c: 3 }
      described_class.convert_keys(simple1, :to_s).each { |k, _| expect(k).class == String }
    end

    it 'converts unary hash key' do
      simple2 = { a: 1 }
      conv = described_class.convert_keys(simple2, :to_s)
      expect(conv['a']).to eq(1)
    end

    it 'converts an array of hash keys' do
      array_hash = { hash: [{ a: 1, b: 2, c: 3 }] }
      conv = described_class.convert_keys(array_hash, :to_s)
      expect(conv).to eq('hash' => [{ 'a' => 1, 'b' => 2, 'c' => 3 }])
    end

    it 'ignores empty hashes' do
      expect { described_class.convert_keys({}, :to_s) }.to_not raise_error
    end

    it 'converts nested hash keys' do
      nested1 = { a: 1, b: { a: 21, b: 22 }, c: 3 }
      conv = described_class.convert_keys(nested1, :to_s)
      conv.each { |k, _| expect(k).class == String }
      expect(conv['b']['a']).to eq(21)
    end

    it 'converts double nested hash keys' do
      nested2 = { a: 1, b: { a: 21, b: { a: 221, b: 222 } }, c: 3 }
      conv = described_class.convert_keys(nested2, :to_s)
      conv.each { |k, _| expect(k).class == String }
      conv['b'].each { |k, _| expect(k).class == String }
      conv['b']['b'].each { |k, _| expect(k).class == String }
    end

    it 'converts empty nested hash keys' do
      nested3 = { a: 1, b: {}, c: 3 }
      conv = described_class.convert_keys(nested3, :to_s)
      conv.each { |k, _| expect(k).class == String }
    end
  end

  describe '::get_diff' do
    before :each do
      @item = OneviewSDK::Resource.new(@client, uri: 'rest/fake', name: 'res', state: 'OK')
      @desired_data = { state: 'Not OK' }
    end

    it 'calls #recursive_diff' do
      expect(described_class).to receive(:recursive_diff).with(@item.data, @desired_data, '', '  ').and_return('diff')
      diff = described_class.get_diff(@item, @desired_data)
      expect(diff).to eq('diff')
    end

    it 'allows a hash values instead of a resource' do
      expect(described_class).to receive(:recursive_diff).with(@item.data, @desired_data, '', '  ').and_return('diff')
      diff = described_class.get_diff(@item.data, @desired_data)
      expect(diff).to eq('diff')
    end

    it 'handles unexpected errors quietly' do
      expect(described_class).to receive(:recursive_diff).and_raise('Unexpected error')
      expect(Chef::Log).to receive(:error).with(/Failed to generate resource diff.*Unexpected error/)
      diff = described_class.get_diff(@item, @desired_data)
      expect(diff).to eq('')
    end
  end

  describe '::recursive_diff' do
    before :each do
      @data = { key1: 'val1', key2: { key3: 'val3', key4: 'val4' }, key5: ['val5.1', 'val5.2'] }
      @item = OneviewSDK::Resource.new(@client, @data)
    end

    it 'returns an empty string if there is no difference' do
      diff = described_class.recursive_diff(@item.data, @item.data)
      expect(diff).to eq('')
    end

    it 'allows you to set the initial string and indent' do
      expect(described_class.recursive_diff('blah', 'newBlah', 'diff:', '  ')).to eq("diff:\n  blah -> newBlah")
    end

    it 'can compare strings' do
      expect(described_class.recursive_diff('blah', 'blah')).to eq('')
      expect(described_class.recursive_diff('blah', 'newBlah')).to eq("\nblah -> newBlah")
      expect(described_class.recursive_diff(nil, 'blah')).to eq("\nnil -> blah")
    end

    it 'can compare arrays' do
      expect(described_class.recursive_diff(['blah'], ['blah'])).to eq('')
      expect(described_class.recursive_diff(['blah'], ['blah', 'newBlah'])).to eq("\n[\"blah\"] -> [\"blah\", \"newBlah\"]")
    end

    it 'can compare hashes' do
      expect(described_class.recursive_diff(@data, @data)).to eq('')
      expect(described_class.recursive_diff(@data, key1: 'val2')).to eq("\nkey1: val1 -> val2")
      expect(described_class.recursive_diff(@data, key2: { key3: 'val2', key4: 'val3' }))
        .to eq("\nkey2:\n  key3: val3 -> val2\n  key4: val4 -> val3")
      expect(described_class.recursive_diff(@data, key5: ['val5.1', 'val5.2'])).to eq('')
      expect(described_class.recursive_diff(@data, key5: ['val1', 'val2']))
        .to eq("\nkey5: [\"val5.1\", \"val5.2\"] -> [\"val1\", \"val2\"]")
    end

    it 'can compare mismatched types' do
      expect(described_class.recursive_diff(nil, ['blah'])).to eq("\nnil -> [\"blah\"]")
      expect(described_class.recursive_diff(nil, ['blah'])).to eq("\nnil -> [\"blah\"]")
      expect(described_class.recursive_diff('blah', ['blah'])).to eq("\nblah -> [\"blah\"]")
      expect(described_class.recursive_diff(['blah'], 'blah')).to eq("\n[\"blah\"] -> blah")
      expect(described_class.recursive_diff(nil, @data)).to eq("\nnil -> #{@data}")
      expect(described_class.recursive_diff({ key2: nil }, @data)).to match(/key1: nil -> val1\n+key2: nil -> #{@data[:key2]}/)
      expect(described_class.recursive_diff({ key2: 1 }, @data)).to match(/key1: nil -> val1\n+key2: 1 -> #{@data[:key2]}/)
    end
  end

  describe '::load_resource' do
    let(:sdk_klass) { OneviewSDK::API200::VolumeTemplate }
    let(:sdk_klass2) { OneviewSDK::ImageStreamer::API300::GoldenImage }
    let(:sdk_klass3) { OneviewSDK::API300::Synergy::VolumeTemplate }

    before :each do
      @data = { name: 'T1', description: 'Blah', uri: '/fake' }
      @res = sdk_klass.new(@client, @data)
      allow(sdk_klass).to receive(:find_by).and_return([@res])
    end

    it 'requires a type' do
      expect { described_class.load_resource(@client) }.to raise_error(ArgumentError, /type/)
    end

    it 'returns immediately without an id' do
      expect(described_class.load_resource(@client, type: :VolumeTemplate)).to eq(nil)
    end

    it 'accepts api_ver & variant params' do
      expect(sdk_klass3).to receive(:find_by).and_return([sdk_klass3.new(@client, @data)])
      expect(OneviewSDK).to receive(:resource_named).with(:VolumeTemplate, 300, :Synergy).and_call_original
      described_class.load_resource(@client, id: 'T1', type: :VolumeTemplate, api_ver: 300, variant: :Synergy)
    end

    it 'pulls the api_ver & variant from the node object' do
      n = { 'oneview' => { 'api_version' => 300, 'api_variant' => 'Synergy' } }
      expect(OneviewSDK).to receive(:resource_named).with(:VolumeTemplate, 300, 'Synergy').and_call_original
      described_class.load_resource(@client, id: 'T1', type: :VolumeTemplate, node: n)
    end

    it 'retrieves a resource successfully when it exists (default by name)' do
      r = described_class.load_resource(@client, type: :VolumeTemplate, id: 'T1')
      expect(r).to be_a(sdk_klass)
      expect(r.data).to eq(@res.data)
    end

    it 'retrieves a resource successfully when it exists (by data Hash)' do
      r = described_class.load_resource(@client, type: :VolumeTemplate, id: { uri: '/fake' })
      expect(r).to be_a(sdk_klass)
      expect(r.data).to eq(@res.data)
    end

    it 'retrieves image streamer resources when they exist' do
      g_image = sdk_klass2.new(@client, name: 'I1', description: 'Image')
      expect(sdk_klass2).to receive(:find_by).and_return([g_image])
      r = described_class.load_resource(@client, type: :GoldenImage, id: 'I1', base_module: OneviewSDK::ImageStreamer, api_ver: 300)
      expect(r).to be_a(sdk_klass2)
      expect(r.data).to eq(g_image.data)
    end

    it 'fails when the resource does not exist' do
      expect_any_instance_of(sdk_klass).to receive(:retrieve!).and_return(false)
      expect { described_class.load_resource(@client, type: :VolumeTemplate, id: 'T2') }
        .to raise_error(OneviewSDK::NotFound, /not found/)
    end

    it 'returns a resource attribute when called with the ret_attribute' do
      r = described_class.load_resource(@client, type: :VolumeTemplate, id: 'T1', ret_attribute: :uri)
      expect(r).to eq('/fake')
    end
  end
end
