require 'pry'
require 'simplecov'

SimpleCov.start do
  add_filter 'spec/'
  add_filter 'matchers.rb'
  add_group 'Libraries', 'libraries'
  add_group 'Resources', 'resources'
  minimum_coverage 98
  minimum_coverage_by_file 97
end

Dir[File.expand_path('../libraries/*.rb', File.dirname(__FILE__))].each { |file| require file }
require 'oneview-sdk'
require 'chef/log'
require 'chefspec'
require 'chefspec/berkshelf'
ChefSpec::Coverage.start!

RSpec.configure do |config|
  # Set the default Fauxhai platform and version
  config.platform = 'redhat'
  config.version = '7.2'

  config.before(:each) do
    # Mock appliance version and login api requests, as well as loading trusted certs
    allow_any_instance_of(OneviewSDK::Client).to receive(:appliance_api_version).and_return(200)
    allow_any_instance_of(OneviewSDK::Client).to receive(:login).and_return('secretToken')
    allow(OneviewSDK::SSLHelper).to receive(:load_trusted_certs).and_return(nil)

    # Clear environment variables
    %w(ONEVIEWSDK_URL ONEVIEWSDK_USER ONEVIEWSDK_PASSWORD ONEVIEWSDK_TOKEN ONEVIEWSDK_SSL_ENABLED).each do |name|
      ENV[name] = nil
    end
  end
end

# General context for unit testing:
RSpec.shared_context 'shared context', a: :b do
  before :each do
    @ov_options = { url: 'https://oneview.example.com', user: 'Administrator', password: 'secret123' }
    @client = OneviewSDK::Client.new(@ov_options)
    @resource = OneviewSDK::Resource.new(@client)
  end
end

# Context for chefspec testing:
RSpec.shared_context 'chef context', a: :b do
  let(:chef_run) do
    runner = ChefSpec::SoloRunner.new
    runner.converge(described_recipe)
  end

  let(:real_chef_run) do
    # NOTE: Must define resource_name in each spec file
    runner = ChefSpec::SoloRunner.new(step_into: ["oneview_#{resource_name}"])
    runner.converge(described_recipe)
  end

  let(:client) do
    OneviewSDK::Client.new(url: 'https://oneview.example.com', user: 'Administrator', password: 'secret123')
  end
end
