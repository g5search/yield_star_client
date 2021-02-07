module YieldStarClient
  class BaseRequest
    include Virtus.model
    include ActiveModel::Validations

    attribute :client_name, String
    attribute :endpoint, String
    attribute :namespace, String
    attribute :username, String
    attribute :password, String
    attribute :logger
    attribute :ssl_version, Symbol, default: :TLSv1_2
    attribute :log, Boolean

    validates(
      :client_name,
      :endpoint,
      :username,
      :password,
      :ssl_version,
      presence: true
    )
    validates :client_name, length: { maximum: 16 }

    def self.execute(attributes)
      new(attributes).execute
    end

    def execute
      raise ArgumentError, errors.full_messages.join('; ') if invalid?

      soap_action = self.class.const_get('SOAP_ACTION')
      raise ArgumentError, 'define SOAP_ACTION' unless soap_action

      SoapClient.request(soap_action, request_args)
    end

    def request_args
      attributes.reject { |_key, value| value.nil? }
    end
  end
end
