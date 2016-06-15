require 'pry'
require 'simplecov'

SimpleCov.start do
  add_filter 'spec/'
  add_group 'Libraries', 'libraries'
  add_group 'Resources', 'resources'
  minimum_coverage 25 # TODO: bump up as we increase coverage. Goal: 95%
  minimum_coverage_by_file 10 # TODO: bump up as we increase coverage. Goal: 90%
end

Dir[File.expand_path('../libraries/*.rb', File.dirname(__FILE__))].each {|file| require file }
require 'oneview-sdk'
require 'chef/log'
require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
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
    @ov_options = { url: 'oneview.example.com', user: 'Administrator', password: 'secret123' }
    @client = OneviewSDK::Client.new(@ov_options)
  end
end
