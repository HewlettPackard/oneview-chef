require 'pry'
require 'simplecov'

SimpleCov.start do
  add_filter 'spec/'
  add_filter 'matchers.rb'
  add_filter '.direnv/'
  add_filter 'libraries/resource_providers/'
  add_group 'Libraries', 'libraries'
  minimum_coverage 95 # Goal: A bit higher
  minimum_coverage_by_file 90 # Goal: much higher
end

Dir[File.expand_path('../libraries/*.rb', File.dirname(__FILE__))].each { |file| require file }
require 'oneview-sdk'
require 'chef/log'
require 'chefspec'
require 'chefspec/berkshelf'
Dir[File.expand_path('./unit/shared_examples/*.rb', File.dirname(__FILE__))].each { |file| require file }
ChefSpec::Coverage.start!

RSpec.configure do |config|
  # Set the default Fauxhai platform and version
  config.platform = 'redhat'
  config.version = '7.2'

  config.before(:each) do
    # Mock appliance version and login api requests, as well as loading trusted certs
    allow_any_instance_of(OneviewSDK::Client).to receive(:appliance_api_version).and_return(500)
    allow_any_instance_of(OneviewSDK::Client).to receive(:login).and_return('secretToken')
    allow(OneviewSDK::SSLHelper).to receive(:load_trusted_certs).and_return(nil)

    # Mock Image stremaer appliance version
    allow_any_instance_of(OneviewSDK::ImageStreamer::Client).to receive(:appliance_i3s_api_version).and_return(300)

    # Clear environment variables
    OneviewSDK::ENV_VARS.each { |name| ENV[name] = nil }
  end
end

# General context for unit testing:
RSpec.shared_context 'shared context', a: :b do
  before :each do
    @ov_options = { url: 'https://oneview.example.com', user: 'Administrator', password: 'secret123' }
    @client = OneviewSDK::Client.new(@ov_options)
    @resource = OneviewSDK::Resource.new(@client)

    @i3s_options = { url: 'https://i3s.example.com', token: 'token123' }
    @i3s_client = OneviewSDK::ImageStreamer::Client.new(@i3s_options)
    @i3s_resource = OneviewSDK::ImageStreamer::Resource.new(@i3s_client)
  end
end

# Context for chefspec testing:
RSpec.shared_context 'chef context', a: :b do
  let(:chef_run) do
    runner = ChefSpec::SoloRunner.new
    runner.converge(described_recipe)
  end

  let(:real_chef_run) do
    # NOTE: Must define resource_name or complete_resource_name in each spec file to use this
    chef_resource_name = resource_name if defined?(resource_name)
    chef_complete_resource_name = complete_resource_name if defined?(complete_resource_name)
    unless chef_resource_name || chef_complete_resource_name
      Chef::Log.warn("Internal error: Undefined 'resource_name' and 'complete_resource_name'. '#{described_recipe}' is very likely to fail!")
    end
    chef_complete_resource_name ||= "oneview_#{chef_resource_name}"
    runner = ChefSpec::SoloRunner.new(step_into: [chef_complete_resource_name])
    runner.converge(described_recipe)
  end

  let(:client) do
    OneviewSDK::Client.new(url: 'https://oneview.example.com', user: 'Administrator', password: 'secret123', api_version: 200)
  end

  let(:client300) do
    OneviewSDK::Client.new(url: 'https://oneview.example.com', user: 'Administrator', password: 'secret123', api_version: 300)
  end

  let(:client500) do
    OneviewSDK::Client.new(url: 'https://oneview.example.com', user: 'Administrator', password: 'secret123', api_version: 500)
  end

  let(:i3s_client300) do
    OneviewSDK::ImageStreamer::Client.new(url: 'https://i3s.example.com', token: 'token123', api_version: 300)
  end
end
