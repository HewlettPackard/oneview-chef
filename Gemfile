source 'https://rubygems.org'

case RUBY_VERSION
when /^2\.0/
  gem 'chef', '~> 12.0', '< 12.9'
  gem 'berkshelf', '~> 4.3'
  gem 'foodcritic', '~> 6.3'
when /^2\.1/
  gem 'chef', '~> 12.0', '< 12.14'
  gem 'berkshelf', '~> 4.3'
  gem 'foodcritic', '~> 7.1'
when /^2\.2\.[01]/
  gem 'chef', '~> 12.0', '< 12.14'
  gem 'berkshelf'
  gem 'foodcritic', '~> 7.1'
else
  gem 'chef', '~> 12.0'
  gem 'berkshelf'
  gem 'foodcritic'
end
gem 'chefspec'
gem 'rubocop', '= 0.40.0'
gem 'oneview-sdk'
gem 'pry'
gem 'simplecov'
gem 'stove'
