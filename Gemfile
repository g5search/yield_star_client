source 'https://rubygems.org'

# Specify your gem's dependencies in yield_star_client.gemspec
gemspec

gem 'pry'
gem 'pry-byebug'
gem 'virtus-matchers', github: 'g5/virtus-matchers'
gem 'simplecov', '~> 0.17.0', require: false
gem 'simplecov-console', require: false

source 'https://gem.fury.io/g5dev/' do
  group :test, :development do
    gem 'g5-rubocop-style'
  end
end
