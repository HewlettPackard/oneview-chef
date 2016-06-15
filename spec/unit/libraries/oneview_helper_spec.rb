require_relative './../../spec_helper'

RSpec.describe 'OneviewHelper' do
  include_context 'shared context'

  let(:helper) do
    (Class.new { include OneviewCookbook::Helper }).new
  end

  let(:sdk_version) do
    '~> 1.0'
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
    # TODO
  end

  describe '#get_resource_named' do
    # TODO
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

    it 'allows the log level to be overridden' do
      level = Chef::Log.level == :warn ? :info : :warn
      ov = helper.build_client(@ov_options.merge(log_level: level))
      expect(ov.log_level).to eq(level)
      expect(ov.log_level).to_not eq(Chef::Log.level)
    end
  end

  describe '#save_res_info' do
    # TODO
  end
end
