require "savon"

require "yield_star_client/property_methods"
require "yield_star_client/floor_plan_methods"
require "yield_star_client/unit_methods"
require "yield_star_client/amenity_methods"
require "yield_star_client/rent_methods"
require "yield_star_client/lease_term_rent_methods"
require "yield_star_client/soap_client"

require "yield_star_client/base_request"
require "yield_star_client/lease_term_request_config"
require "yield_star_client/base_response"
require "yield_star_client/lease_term_response_config"

require "yield_star_client/get_properties/request"
require "yield_star_client/get_properties/response"
require "yield_star_client/get_property/request"
require "yield_star_client/get_property/response"
require "yield_star_client/get_property_parameters/request"
require "yield_star_client/get_property_parameters/response"
require "yield_star_client/get_lease_term_rent/request"
require "yield_star_client/get_lease_term_rent/response"
require "yield_star_client/get_floor_plan_amenities/request"
require "yield_star_client/get_floor_plan_amenities/response"
require "yield_star_client/get_unit_amenities/request"
require "yield_star_client/get_unit_amenities/response"
require "yield_star_client/get_rent_summary/request"
require "yield_star_client/get_rent_summary/response"
require "yield_star_client/get_available_units/request"
require "yield_star_client/get_available_units/response"
require "yield_star_client/get_units/request"
require "yield_star_client/get_units/response"
require "yield_star_client/get_unit/request"
require "yield_star_client/get_unit/response"
require "yield_star_client/get_floor_plans/request"
require "yield_star_client/get_floor_plans/response"
require "yield_star_client/get_floor_plan/request"
require "yield_star_client/get_floor_plan/response"

require "yield_star_client/extract_lease_term_rent_hashes"

require "yield_star_client/errors"

module YieldStarClient
  # YieldStarClient::Client is the main object for connecting to the YieldStar AppExchange service.
  # The interface strives to be SOAP-agnostic whenever possible; all inputs and outputs are pure ruby
  # and no knowledge of SOAP is required in order to use the client.
  class Client
    include PropertyMethods
    include FloorPlanMethods
    include UnitMethods
    include AmenityMethods
    include RentMethods
    include LeaseTermRentMethods

    attr_accessor :configuration

    delegate *YieldStarClient::VALID_CONFIG_OPTIONS, to: :configuration

    # Initializes the client. All options are truly optional; if the option
    # is not supplied to this method, then it will be set based on the
    # YieldStarClient configuration.
    #
    # @see YieldStarClient.configure
    #
    # @param [Hash] options
    # @option options [String] :username The username for authenticating to the web service.
    # @option options [String] :password The password for authenticating to the web service.
    # @option options [String] :client_name The YieldStar client name (required for all requests)
    # @option options [String] :endpoint The address for connecting to the web service.
    # @option options [String] :namespace The XML namespace to use for requests.
    # @option options [Symbol] :ssl_version The TLS version used for secure connections
    # @option options [true,false] :debug true to enable debug logging of SOAP traffic; defaults to false

    def initialize(options={})
      @configuration = Configuration.new(options)
    end

    private

    # Sends a request directly to the SOAP service.
    #
    # @param [Symbol] soap_action the action to be invoked
    # @param [Hash] soap_parameters the parameters to populate the request body
    # @return [Savon::SOAP::Response]
    def send_soap_request(soap_action, soap_parameters = {})
      validate_client_name!(client_name)
      default_params = {client_name: client_name}
      begin
        message = default_params.merge(soap_parameters)
        soap_client.call(
          soap_action,
          message: {request: message}
        )
      rescue Savon::SOAPFault => e
        raise ServerError.translate_fault(e)
      end
    end

    # Sets up a SOAP client for sending SOAP requests directly.
    #
    # @return [Savon::Client]
    def soap_client
      @soap_client ||= Savon.client(
        element_form_default: :qualified,
        endpoint: endpoint.to_s,
        namespace: namespace,
        basic_auth: [username.to_s, password.to_s],
        log: log,
        logger: logger,
        ssl_version: ssl_version,
      )
    end

    def default_savon_params
      @configuration.to_h
    end
    
  end
end
