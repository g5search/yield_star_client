require 'yield_star_client/validations'

module YieldStarClient
  # Represents a floor plan with available units.
  #
  # @attr [String] external_property_id the ID of the property associated with the
  #                                     floor plan
  # @attr [Date] effective_date the date that all listed prices are considered effective
  # @attr [String] floor_plan_name the name of the floor plan that matches the
  #                                Price Optimizer dashboard
  # @attr [Array<AvailableUnit>] units the available unit data associated with this
  #                                    floor plan
  # @attr [Float] bedrooms the number of bedrooms in this floor plan
  # @attr [Float] bathrooms the number of bathrooms in this floor plan
  # @attr [Integer] square_feet the square footage of the floor plan
  class AvailableFloorPlan < Modelish::Base
    property :external_property_id
    property :effective_date, :type => Date
    property :floor_plan_name
    property :bedrooms, :type => Float, :from => :bed_rooms
    property :bathrooms, :type => Float, :from => :bath_rooms
    property :square_feet, :type => Integer, :from => :sq_ft
    property :units, :from => :unit, :default => []

    def initialize(options = {})
      super(options)

      # TODO: add support for nested types to modelish?
      self.units = [self.units].flatten.collect { |u| AvailableUnit.new(u) }
    end
  end

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
  class AvailableUnit < Modelish::Base
    property :building
    property :unit_type
    property :unit_number
    property :features, :type => Array, :default => [], :from => :feature
    property :status, :type => Symbol
    property :date_available, :type => Date
    property :base_market_rent, :type => Integer
    property :base_concession, :type => Integer
    property :base_final_rent, :type => Integer
    property :best_lease_term, :type => Integer
    property :best_market_rent, :type => Integer
    property :best_concession, :type => Integer
    property :best_final_rent, :type => Integer
  end

  module RentMethods
    # Retrieves high-level rent information for all currently available floor
    # plans within a specific property.
    #
    # @param [String] external_property_id the ID of the property associated
    #                                      with the requested data
    #
    # @return [Array<YieldStarClient::RentSummary>]
    #
    # @raise [ArgumentError] when a required argument is missing or invalid
    # @raise [YieldStarClient::AuthenticationError] when unable to authenticate to the web service
    # @raise [YieldStarClient::OperationError] when the service raises an OperationError fault
    # @raise [YieldStarClient::InternalError] when the service raises an InternalError fault
    # @raise [YieldStarClient::ServerError] when any other server-side error occurs
    def get_rent_summary(external_property_id)
      validate_external_property_id!(external_property_id)

      response = send_soap_request(:get_rent_summary, :external_property_id => external_property_id)

      data = response.to_hash[:get_rent_summary_response][:return]
      shared_props = {:external_property_id => data[:external_property_id],
                      :effective_date => data[:effective_date]}
      summaries = []
      summaries << data[:floor_plan_unit_type] if data[:floor_plan_unit_type]

      summaries.flatten.collect { |s| RentSummary.new(shared_props.merge(s)) }
    end

    # Retrieves rental information for all currently available units at a specific
    # property, grouped by floor plan.
    #
    # @param [String] external_property_id the ID of the property where the available
    #                                      units are located
    #
    # @return [Array<YieldStarClient::AvailableFloorPlan>] list of floor plans with
    #                                                      available units
    #
    # @raise [ArgumentError] when a required argument is missing or invalid
    # @raise [YieldStarClient::AuthenticationError] when unable to authenticate to the web service
    # @raise [YieldStarClient::OperationError] when the service raises an OperationError fault
    # @raise [YieldStarClient::InternalError] when the service raises an InternalError fault
    # @raise [YieldStarClient::ServerError] when any other server-side error occurs
    def get_available_units(external_property_id)
      validate_external_property_id!(external_property_id)

      response = send_soap_request(:get_available_units, :external_property_id => external_property_id)

      data = response.to_hash[:get_available_units_response][:return]
      base_props = data.reject { |k,v| ![:external_property_id, :effective_date].include?(k) }

      floor_plans = []
      floor_plans << data[:floor_plan] if data[:floor_plan]

      floor_plans.flatten.collect { |fp| AvailableFloorPlan.new(base_props.merge(fp)) }
    end
  end
end
