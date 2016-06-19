module YieldStarClient
  # Represents a property in the YieldStar system.
  #
  # A property is guaranteed to have an +external_property_id+ and +name+; all other attributes are optional.
  #
  # @attr [String] external_property_id the property ID
  # @attr [String] name the name of the property
  # @attr [String] address the street address
  # @attr [String] city the city in which the property is located
  # @attr [String] state the two-letter code of the state in which the property is located
  # @attr [String] zip the zip code
  # @attr [String] fax the fax telephone number
  # @attr [String] phone the voice telephone number
  # @attr [Float] latitude the latitude of the property's location
  # @attr [Float] longitude the longitude of the property's location
  # @attr [Integer] unit_count the number of units at this property
  # @attr [String] website the URL of the property website
  # @attr [Integer] year_built the year in which the property was built
  class Property
    include Virtus.model

    attribute :external_property_id
    attribute :name
    attribute :address
    attribute :city
    attribute :state
    attribute :zip
    attribute :fax
    attribute :phone
    attribute :latitude, Float
    attribute :longitude, Float
    attribute :unit_count, Integer
    attribute :website
    attribute :year_built, Integer
  end
end
