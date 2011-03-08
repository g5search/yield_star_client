require 'validations'
require 'base_model'

module YieldStarClient
  # Represents a floor plan in the YieldStar system.
  #
  # A floor plan is guaranteed to have an +external_property_id+ and +name+. All other attributes are
  # optional.
  #
  # @attr [String] external_property_id the property ID of this floor plan
  # @attr [String] name the name of this floor plan
  # @attr [String] description the description of this floor plan
  # @attr [Integer] square_footage the average square footage of this floor plan
  # @attr [Integer] unit_count the number of units with this floor plan
  # @attr [Float] bedrooms the bedroom count of the floor plan
  # @attr [Float] bathrooms the bathroom count of the floor plan
  class FloorPlan < BaseModel
    property :external_property_id
    property :name
    property :description
    property :square_footage, :type => Integer
    property :unit_count, :type => Integer
    property :bedrooms, :type => Float, :from => :bed_rooms
    property :bathrooms, :type => Float, :from => :bath_rooms
  end

  module FloorPlanMethods
    include Validations

    # Retrieves all floor plans for a particular property.
    #
    # @param [String] client_name the YieldStar client name
    # @param [String] external_property_id the ID of the property
    # @return [Array<YieldStarClient::FloorPlan>] list of floor plans
    #
    # @raise [ArgumentError] when client_name or external_property_id is missing or invalid
    # @raise [YieldStarClient::AuthenticationError] when unable to authenticate to the web service
    # @raise [YieldStarClient::OperationError] when the service raises an OperationError fault
    # @raise [YieldStarClient::InternalError] when the service raises an InternalError fault
    # @raise [YieldStarClient::ServerError] when any other server-side error occurs
    def get_floor_plans(client_name, external_property_id)
      validate_client_name(client_name)
      validate_external_property_id(external_property_id)

      response = send_soap_request(:get_floor_plans, :client_name => client_name, :external_property_id => external_property_id)

      floor_plans = response.to_hash[:get_floor_plans_response][:return][:floor_plan] || []
      floor_plans = [floor_plans].flatten

      floor_plans.collect { |fp| FloorPlan.new(fp) }
    end

    # Retrieves a specific floor plan.
    #
    # @param [String] client_name the YieldStar client name
    # @param [String] external_property_id the ID of the property
    # @param [String] floor_plan_name the name of the floor plan
    # @return [YieldStarClient::FloorPlan] the floor plan data
    #
    # @raise [ArgumentError] when a parameter is missing or invalid
    # @raise [YieldStarClient::AuthenticationError] when unable to authenticate to the web service
    # @raise [YieldStarClient::OperationError] when the service raises an OperationError fault
    # @raise [YieldStarClient::InternalError] when the service raises an InternalError fault
    # @raise [YieldStarClient::ServerError] when any other server-side error occurs
    def get_floor_plan(client_name, external_property_id, floor_plan_name)
      validate_client_name(client_name)
      validate_external_property_id(external_property_id)
      validate_required(:floor_plan_name => floor_plan_name)

      response = send_soap_request(:get_floor_plan, :client_name => client_name, 
                                                    :external_property_id => external_property_id, 
                                                    :name => floor_plan_name)
      floor_plan = response.to_hash[:get_floor_plan_response][:return][:floor_plan]

      FloorPlan.new(floor_plan)
    end
  end
end
