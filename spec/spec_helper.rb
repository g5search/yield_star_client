require 'bundler'
Bundler.require :default, :development

require 'pry'
require 'rspec'
# require "yaml"
require 'savon/mock/spec_helper'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/numeric'
require 'factory_bot'
require 'virtus-matchers'
require 'shoulda/matchers'
require 'vcr'
require 'active_support/all'
require 'simplecov'
require 'yield_star_client/factories'

SimpleCov.start

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :active_model
  end
end

SPEC_DIR = File.expand_path(__dir__)
CONFIG = YAML.load_file(File.join(SPEC_DIR, 'config.yml')).
         with_indifferent_access

Dir[File.join(File.dirname(__FILE__), 'support', '**', '*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.include Virtus::Matchers
  config.include WebMock::API
  config.include Savon::SpecHelper
  config.include FactoryBot::Syntax::Methods
end

require 'yield_star_client'
