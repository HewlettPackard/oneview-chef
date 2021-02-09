source 'https://rubygems.org'

ruby RUBY_VERSION # Needed to consider & solve for Ruby version requirements

gem 'berkshelf', '~> 6.3.4'
# Workaround due to bug in Chef v12.21.20. Waiting for gem with the fix being released on RubyGems
chef_version = Gem::Version.new(RUBY_VERSION) > Gem::Version.new('2.3.0') ? '>= 13.0' : '<= 12.21.14'
# gem 'chef', '~> 13.12.3'
gem 'chef', chef_version
gem 'chefspec'
gem 'codeclimate-test-reporter'
gem 'cucumber-core', '~> 3.2.1'
gem 'foodcritic', '~> 7.1.0'
gem 'oneview-sdk', '~> 5.18.0'
gem 'pry'
gem 'rubocop', '~> 0.49.1'
gem 'simplecov', '~> 0.17.1'
gem 'stove'

begin
  if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('2.2.6')
    group :development do
      gem 'guard-rake'
      gem 'guard-rspec'
      gem 'guard-rubocop'
    end
  end
rescue StandardError
  "no big deal; you just can't use guard"
end
