module YieldStarClient
  class SoapClient
    SAVON_CLIENT_PARAMS = %i[
      endpoint
      namespace
      log
      logger
      username
      password
      ssl_version
    ].freeze

    def self.request(action, params)
      request_params = params
      savon_client_params = savon_client_params_from(params)

      savon_client = ::Savon.client(savon_client_params)
      savon_client.call(
        action,
        message: {
          request: request_params,
        },
      )
    rescue Savon::SOAPFault, Savon::HTTPError => e
      raise ServerError.translate_fault(e)
    end

    def self.savon_client_params_from(params)
      savon_client_params = SAVON_CLIENT_PARAMS.each_with_object({}) do |key, hash|
        hash[key] = params.delete(key)
      end

      savon_client_params[:basic_auth] = [
        savon_client_params.delete(:username),
        savon_client_params.delete(:password),
      ]
      savon_client_params[:element_form_default] = :qualified
      savon_client_params
    end
  end
end
