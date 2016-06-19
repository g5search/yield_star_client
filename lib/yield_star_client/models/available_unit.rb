module YieldStarClient

  # Represents an available unit.
  #
  # @attr [String] building the building for this unit
  # @attr [String] unit_type the unit type
  # @attr [String] unit_number the unit number from the property management system
  # @attr [Array<String>] features the list of unit amenities/features
  # @attr [Symbol] status the availability status of this unit. The status may be one of the
  #                       following values:
  #                       * +:on_notice+
  #                       * +:vacant+
  #                       * +:new_unit+
  #                       * +:unknown+
  # @attr [Date] date_available the date this unit can be occupied
  # @attr [Integer] base_market_rent the 12-month market rent
  # @attr [Integer] base_concession the concession amountt
  # @attr [Integer] base_final_rent the 12-month effective rent (market rent less concessions)
  # @attr [Integer] best_lease_term the lease term associated with the best price from
  #                                 the Lease Term Rent Matrix.
  # @attr [Integer] best_market_rent the market monthly rent associated with the best price
  #                                  term and move-in period
  # @attr [Integer] best_concession the concession associated with the best price term
  #                                 and move-in period
  # @attr [Integer] best_final_rent the effective monthly rent associated with the best
  #                                 price term and move-in period
  class AvailableUnit
    include Virtus.model

    attribute :building
    attribute :unit_type
    attribute :unit_number
    attribute :features, Array, default: []
    attribute :status, Symbol
    attribute :date_available, Date
    attribute :base_market_rent, Integer
    attribute :base_concession, Integer
    attribute :base_final_rent, Integer
    attribute :best_lease_term, Integer
    attribute :best_market_rent, Integer
    attribute :best_concession, Integer
    attribute :best_final_rent, Integer

    def self.new(attributes={})
      attributes[:features] = attributes.delete :feature

      super(attributes)
    end

    def id
      concat = [building, unit_type, unit_number].join("-")
      Digest::SHA1.hexdigest concat
    end
  end

end
