require_relative './../../spec_helper'
require 'chef/node'

RSpec.describe OneviewCookbook::Helper do
  include_context 'shared context'

  let(:helper) do
    (Class.new { include OneviewCookbook::Helper }).new
  end

  let(:sdk_version) do
    '~> 2.1'
  end

  describe '#load_sdk' do
    before :each do
      allow(helper).to receive(:node).and_return('oneview' => { 'ruby_sdk_version' => sdk_version })
    end

    it 'loads the specified version of the gem' do
      expect(helper).to receive(:gem).with('oneview-sdk', sdk_version)
      helper.load_sdk
    end

    it 'attempts to install the gem if it is not found' do
      expect(helper).to receive(:gem).once.and_raise LoadError
      expect(helper).to receive(:gem).once.and_return true
      expect(helper).to receive(:chef_gem).with('oneview-sdk').and_return true
      expect(helper).to receive(:require).with('oneview-sdk').and_return true
      helper.load_sdk
    end

    it 'prints an error message if the gem cannot be loaded either time' do
      expect(helper).to receive(:gem).twice.and_raise LoadError, 'Blah'
      expect(Chef::Log).to receive(:error).with(/cannot be loaded. Message: Blah/)
      expect(Chef::Log).to receive(:error).with(/Loaded version .* instead/)
      expect(helper).to receive(:chef_gem).with('oneview-sdk').and_return true
      expect(helper).to receive(:require).with('oneview-sdk').and_return true
      helper.load_sdk
    end
  end

  describe '#load_resource' do
    before :each do
      allow(helper).to receive(:client).and_return @client
      allow(helper).to receive(:resource_name).and_return 'oneview_ethernet_network'
      allow(helper).to receive(:data).and_return(name: 'net')
      allow(helper).to receive(:load_sdk).and_return true
      allow(helper).to receive(:api_module).and_return @client.api_version
      allow(helper).to receive(:api_variant).and_return 'C7000'
      allow(helper).to receive(:property_is_set?).with(:api_version).and_return false
    end

    it 'loads the sdk' do
      expect(helper).to receive(:load_sdk).and_raise 'Called load_sdk'
      expect { helper.load_resource }.to raise_error 'Called load_sdk'
    end

    it 'respects the type property' do
      expect(helper).to receive(:type).and_return 'server_profile'
      item = helper.load_resource
      expect(item).to be_a OneviewSDK::ServerProfile
    end

    it 'infers the type from the resource_name' do
      item = helper.load_resource
      expect(item).to be_a OneviewSDK::EthernetNetwork
    end

    it 'sets the name if none is given in the data hash' do
      allow(helper).to receive(:data).and_return({})
      expect(helper).to receive(:name).and_return('other_net')
      item = helper.load_resource
      expect(item[:name]).to eq('other_net')
    end

    it 'converts the data hash to a json-safe format' do
      allow(helper).to receive(:data).and_return(name: 'net', key2: { key3: :val3 })
      item = helper.load_resource
      expect(item['key2']['key3']).to eq('val3')
    end
  end

  describe '#get_resource_named' do
    before :each do
      allow(helper).to receive(:api_module).and_return @client.api_version
      allow(helper).to receive(:api_variant).and_return 'C7000'
    end

    it 'returns a class from a valid snake_case name' do
      r = helper.get_resource_named('server_profile')
      expect(r).to be OneviewSDK::ServerProfile
    end

    it 'returns a class from a valid camelCase name' do
      r = helper.get_resource_named('serverProfile')
      expect(r).to be OneviewSDK::ServerProfile
    end

    it 'fails if an invalid name is given' do
      expect { helper.get_resource_named('') }.to raise_error(/Invalid OneView Resource type/)
      expect { helper.get_resource_named('invalid') }.to raise_error(/Invalid OneView Resource type/)
    end
  end

  describe '#build_client' do
    it 'requires a parameter' do
      expect { helper.build_client }.to raise_error(/wrong number of arguments/)
    end

    it 'requires a valid oneview object' do
      expect { helper.build_client(nil) }.to raise_error(/Invalid client/)
    end

    it 'accepts an OneviewSDK::Client object' do
      ov = helper.build_client(@client)
      expect(ov).to eq(@client)
    end

    it 'accepts a hash' do
      ov = helper.build_client(@ov_options)
      expect(ov.url).to eq(@ov_options[:url])
      expect(ov.user).to eq(@ov_options[:user])
      expect(ov.password).to eq(@ov_options[:password])
    end

    it 'defaults the log level to what Chef is using' do
      ov = helper.build_client(@ov_options)
      expect(ov.log_level).to eq(Chef::Log.level)
    end

    it 'defaults to the Chef logger and log level' do
      ov = helper.build_client(@ov_options)
      expect(ov.logger).to eq(Chef::Log)
      expect(ov.log_level).to eq(Chef::Log.level)
    end

    it "doesn't allow the log level to be overridden when no logger is specified" do
      level = Chef::Log.level == :warn ? :info : :warn
      ov = helper.build_client(@ov_options.merge(log_level: level))
      expect(ov.log_level).to_not eq(level)
      expect(ov.log_level).to eq(Chef::Log.level)
    end

    it 'allows the log level to be overridden if the logger is specified' do
      level = Chef::Log.level == :warn ? :info : :warn
      ov = helper.build_client(@ov_options.merge(logger: Logger.new(STDOUT), log_level: level))
      expect(ov.log_level).to eq(level)
      expect(ov.log_level).to_not eq(Chef::Log.level)
    end
  end

  describe '#save_res_info' do
    before :each do
      @name = 'res1'
      @data = { 'uri' => 'rest/fake', 'name' => @name, 'status' => 'OK' }
      @item = OneviewSDK::Resource.new(@client, @data)
      @node = Chef::Node.new
      allow(helper).to receive(:node).and_return @node
    end

    it "saves everything when 'true' is passed in" do
      helper.save_res_info(true, @name, @item)
      expect(@node['oneview'][@client.url][@name]).to eq(@data)
    end

    it 'can save a subset of values' do
      helper.save_res_info(['uri', 'name'], @name, @item)
      expect(@node['oneview'][@client.url][@name]).to eq('uri' => 'rest/fake', 'name' => @name)
    end

    it "saves nothing when 'false' is passed in" do
      helper.save_res_info(false, @name, @item)
      expect(@node['oneview']).to be_nil
    end

    it 'prints to the Chef error log when it fails to save the data' do
      expect(Chef::Log).to receive(:error).with(/Failed to save resource data/)
      helper.save_res_info([], @name, nil)
    end
  end

  describe '#convert_keys' do
    it 'converts simple hash keys' do
      simple_1 = { a: 1, b: 2, c: 3 }
      helper.convert_keys(simple_1, :to_s).each { |k, _| expect(k).class == String }
    end

    it 'converts unary hash key' do
      simple_2 = { a: 1 }
      conv = helper.convert_keys(simple_2, :to_s)
      expect(conv['a']).to eq(1)
    end

    it 'ignores empty hashes' do
      expect { helper.convert_keys({}, :to_s) }.to_not raise_error
    end

    it 'converts nested hash keys' do
      nested_1 = { a: 1, b: { a: 21, b: 22 }, c: 3 }
      conv = helper.convert_keys(nested_1, :to_s)
      conv.each { |k, _| expect(k).class == String }
      expect(conv['b']['a']).to eq(21)
    end

    it 'converts double nested hash keys' do
      nested_2 = { a: 1, b: { a: 21, b: { a: 221, b: 222 } }, c: 3 }
      conv = helper.convert_keys(nested_2, :to_s)
      conv.each { |k, _| expect(k).class == String }
      conv['b'].each { |k, _| expect(k).class == String }
      conv['b']['b'].each { |k, _| expect(k).class == String }
    end

    it 'converts empty nested hash keys' do
      nested_3 = { a: 1, b: {}, c: 3 }
      conv = helper.convert_keys(nested_3, :to_s)
      conv.each { |k, _| expect(k).class == String }
    end
  end

  describe '#get_diff' do
    before :each do
      @item = OneviewSDK::Resource.new(@client, uri: 'rest/fake', name: 'res', state: 'OK')
      @desired_data = { state: 'Not OK' }
    end

    it 'calls #recursive_diff' do
      expect(helper).to receive(:recursive_diff).with(@item.data, @desired_data, "\n", '  ').and_return('diff')
      diff = helper.get_diff(@item, @desired_data)
      expect(diff).to eq('diff')
    end

    it 'allows a hash values instead of a resource' do
      expect(helper).to receive(:recursive_diff).with(@item.data, @desired_data, "\n", '  ').and_return('diff')
      diff = helper.get_diff(@item.data, @desired_data)
      expect(diff).to eq('diff')
    end

    it 'handles unexpected errors quietly' do
      expect(helper).to receive(:recursive_diff).and_raise('Unexpected error')
      expect(Chef::Log).to receive(:error).with(/Failed to generate resource diff.*Unexpected error/)
      diff = helper.get_diff(@item, @desired_data)
      expect(diff).to eq('')
    end
  end

  describe '#recursive_diff' do
    before :each do
      @data = { key1: 'val1', key2: { key3: 'val3', key4: 'val4' }, key5: ['val5.1', 'val5.2'] }
      @item = OneviewSDK::Resource.new(@client, @data)
    end

    it 'returns an empty string if there is no difference' do
      diff = helper.recursive_diff(@item.data, @item.data)
      expect(diff).to eq('')
    end

    it 'allows you to set the initial string and indent' do
      expect(helper.recursive_diff('blah', 'newBlah', 'diff:', '  ')).to eq("diff:\n  blah -> newBlah")
    end

    it 'can compare strings' do
      expect(helper.recursive_diff('blah', 'blah')).to eq('')
      expect(helper.recursive_diff('blah', 'newBlah')).to eq("\nblah -> newBlah")
      expect(helper.recursive_diff(nil, 'blah')).to eq("\nnil -> blah")
    end

    it 'can compare arrays' do
      expect(helper.recursive_diff(['blah'], ['blah'])).to eq('')
      expect(helper.recursive_diff(['blah'], ['blah', 'newBlah'])).to eq("\n[\"blah\"] -> [\"blah\", \"newBlah\"]")
    end

    it 'can compare hashes' do
      expect(helper.recursive_diff(@data, @data)).to eq('')
      expect(helper.recursive_diff(@data, key1: 'val2')).to eq("\nkey1: val1 -> val2")
      expect(helper.recursive_diff(@data, key2: { key3: 'val2', key4: 'val3' }))
        .to eq("\nkey2:\n  key3: val3 -> val2\n  key4: val4 -> val3")
      expect(helper.recursive_diff(@data, key5: ['val5.1', 'val5.2'])).to eq('')
      expect(helper.recursive_diff(@data, key5: ['val1', 'val2']))
        .to eq("\nkey5: [\"val5.1\", \"val5.2\"] -> [\"val1\", \"val2\"]")
    end

    it 'can compare mismatched types' do
      expect(helper.recursive_diff(nil, ['blah'])).to eq("\nnil -> [\"blah\"]")
      expect(helper.recursive_diff(nil, ['blah'])).to eq("\nnil -> [\"blah\"]")
      expect(helper.recursive_diff('blah', ['blah'])).to eq("\nblah -> [\"blah\"]")
      expect(helper.recursive_diff(['blah'], 'blah')).to eq("\n[\"blah\"] -> blah")
      expect(helper.recursive_diff(nil, @data)).to eq("\nnil -> #{@data}")
      expect(helper.recursive_diff({ key2: nil }, @data)).to match(/key1: nil -> val1\n+key2: nil -> #{@data[:key2]}/)
      expect(helper.recursive_diff({ key2: 1 }, @data)).to match(/key1: nil -> val1\n+key2: 1 -> #{@data[:key2]}/)
    end
  end
end
