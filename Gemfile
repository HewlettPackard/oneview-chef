source 'https://rubygems.org'

ruby RUBY_VERSION # Needed to consider & solve for Ruby version requirements

gem 'berkshelf'
gem 'chef', '~> 12.0'
gem 'chefspec'
gem 'codeclimate-test-reporter', '~> 1.0.0'
gem 'foodcritic'
gem 'oneview-sdk', '~> 5.0.0'
gem 'pry'
gem 'rubocop', '= 0.40.0'
gem 'simplecov'
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
