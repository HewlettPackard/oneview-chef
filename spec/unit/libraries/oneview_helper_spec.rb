require_relative './../../spec_helper'
require 'chef/node'

RSpec.describe OneviewCookbook::Helper do
  include_context 'shared context'

  let(:helper) do
    (Class.new { include OneviewCookbook::Helper }).new
  end

  let(:sdk_version) do
    '= 2.0.0'
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
      expect(helper).to receive(:gem).and_raise LoadError
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
  end

  describe '#get_resource_named' do
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
end
