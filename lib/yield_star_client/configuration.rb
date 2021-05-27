require 'logger'

module YieldStarClient
  # All valid configuration options.
  #
  # @see YieldStarClient.configure
  VALID_CONFIG_OPTIONS = [:endpoint, :username, :password, :namespace, :client_name,
                          :log, :logger, :ssl_version]

  DEFAULT_ENDPOINT = ENV.fetch("YIELD_STAR_ENDPOINT", 'https://rmsws.yieldstar.com/rmsws/AppExchange').freeze
  DEFAULT_NAMESPACE = ENV.fetch("YIELD_STAR_NAMESPACE", 'http://yieldstar.com/ws/AppExchange/v1').freeze
  DEFAULT_SSL_VERSION = :TLSv1_2

  class Configuration
    include Virtus.model

    attribute :client_name, String
    attribute :endpoint, String, default: DEFAULT_ENDPOINT
    attribute :namespace, String, default: DEFAULT_NAMESPACE
    attribute :username, String
    attribute :password, String
    attribute :logger, Logger, default: Logger.new(STDOUT)
    attribute :ssl_version, Symbol, default: DEFAULT_SSL_VERSION
    attribute :log, Boolean, default: false

    # Resets this module's configuration.
    # Configuration options will be set to default values
    # if they exist; otherwise, they will be set to nil.
    #
    # @see VALID_CONFIG_OPTIONS
    # @see DEFAULT_ENDPOINT
    # @see DEFAULT_NAMESPACE
    def reset
      VALID_CONFIG_OPTIONS.each { |opt| self.reset_attribute(opt) }
    end
  end
end
