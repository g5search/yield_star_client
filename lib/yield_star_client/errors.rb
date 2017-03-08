module YieldStarClient
  # Represents a server-side error returned by the YieldStar web service.
  class ServerError < StandardError
    attr_reader :code

    # Creates a new error object.
    #
    # @param [String] message the error message. If no message is supplied, the
    #                 object's class name will be used as the message.
    # @param [String] code the error code    
    def initialize(message=nil, code=nil)
      super(message)
      @code = code
    end

    # Translates a soap fault into the appropriate YieldStarClient error.
    #
    # @param [Savon::SOAP::Fault] soap_error the error object raised by the soap client
    # @return [YieldStarClient::ServerError] the corresponding YieldStarClient error
    def self.translate_fault(error)
      if error.instance_of? Savon::HTTPError
        http_build_error_object(error)
      elsif error.instance_of? Savon::SOAPFault
        soap_build_error_object(error)
      end
    end

    private

    def self.http_build_error_object(http_error)
      http_error_hash = http_error.to_hash
      code = http_error_hash[:code]
      body = http_error_hash[:body]

      case code
      when 401
        YieldStarClient::AuthenticationError.new("Authentication Error", code)
      else
        YieldStarClient::ServerError.new(body, code)
      end
    end

    def self.soap_build_error_object(soap_error)
      soap_error_hash = soap_error.to_hash[:fault]
      detail = soap_error_hash[:detail]

      error_class = if detail && detail.has_key?(:authentication_fault)
        message = detail[:authentication_fault][:message]
        code = detail[:authentication_fault][:code]
        YieldStarClient::AuthenticationError.new(message, code)
      elsif detail && detail.has_key?(:operation_fault)
        message = detail[:operation_fault][:message]
        code = detail[:operation_fault][:code]
        YieldStarClient::OperationError.new(message, code)
      elsif detail && detail.has_key?(:internal_error_fault)
        message = detail[:internal_error_fault][:message]
        code = detail[:internal_error_fault][:code]
        YieldStarClient::InternalError.new(message, code)
      else
        message = soap_error_hash[:faultstring]
        code = soap_error_hash[:faultcode]
        YieldStarClient::ServerError.new(message, code)
      end
    end
  end

  # Represents an error in authenticating to the web service
  class AuthenticationError < ServerError; end

  # Represents an internal error in the web service
  class InternalError < ServerError; end

  # Represents an operation error in the web service
  class OperationError < ServerError; end
end
