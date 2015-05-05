require 'yield_star_client/version'
require 'yield_star_client/configuration'
require 'modelish'
require 'yield_star_client/models/rent_summary'

module YieldStarClient
  extend Configuration

  require 'yield_star_client/client'
end
