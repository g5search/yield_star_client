module YieldStarClient
  # Represents a unit in the YieldStar system.
  #
  # A unit is guaranteed to have an +external_property_id+, +floor_plan_name+, +name+, and +availablity_status+.
  # All other attributes are optional.
  #
  # @attr [String] external_property_id the property ID
  # @attr [String] floor_plan_name the name of the unit's floor plan
  # @attr [String] name the unit name
  # @attr [Symbol] availability_status the current availability of the unit. This may be one of the following values:
  #   * +:occupied+ -- this unit is presently leased by a resident
  #   * +:occupied_on_notice+ -- this unit is presently leased by a resident but a notice date has been provided
  #   * +:vacant+ -- this unit is not presently leased
  #   * +:pending+ -- this unit is available but a lease is pending
  #   * +:unknown+ -- the status is unknown or unrecognized
  # @attr [String] building the name of the building associated with the unit
  # @attr [Float] bedrooms the number of bedrooms in the unit
  # @attr [Float] bathrooms the number of bathrooms in the unit
  # @attr [Integer] square_feet the square footage of the unit
  # @attr [String] unit_type the client-defined grouping of the unit
  # @attr [Date] make_ready_date the date on which the unit is ready for move-in
  class Unit
    include Virtus.model

    attribute :external_property_id, String
    attribute :floor_plan_name, String
    attribute :name, String
    attribute :availability_status, Symbol
    attribute :building, String
    attribute :bedrooms, Float
    attribute :bathrooms, Float
    attribute :square_feet, Integer
    attribute :unit_type, String
    attribute :make_ready_date, Date

    def self.new(attributes)
      attributes[:bedrooms] = attributes.delete :bed_rooms
      attributes[:bathrooms] = attributes.delete :bath_rooms
      attributes[:square_feet] = attributes.delete :square_footage

      super(attributes)
    end

  end

end
