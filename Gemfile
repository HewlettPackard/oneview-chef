source 'https://rubygems.org'

case RUBY_VERSION
when /^2\.0/
  gem 'chef', '~> 12.0', '< 12.9'
  gem 'berkshelf', '~> 4.3'
when /^2\.1/
  gem 'chef', '~> 12.0', '< 12.14'
  gem 'berkshelf', '~> 4.3'
when /^2\.2\.[01]/
  gem 'chef', '~> 12.0', '< 12.14'
  gem 'berkshelf'
else
  gem 'chef', '~> 12.0'
  gem 'berkshelf'
end
gem 'chefspec'
gem 'foodcritic'
gem 'rubocop', '= 0.40.0'
gem 'oneview-sdk'
gem 'pry'
gem 'simplecov'
gem 'stove'
