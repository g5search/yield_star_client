require "spec_helper"

describe YieldStarClient::Client do
  subject { client }

  let(:configuration) { client.configuration }
  after { configuration.reset }

  let(:client) do
    YieldStarClient::Client.new({endpoint: endpoint,
                                 username: username,
                                 password: password,
                                 namespace: namespace,
                                 ssl_version: ssl_version,
                                 client_name: client_name,
                                 log: log,
                                 logger: logger})

  end

  let(:endpoint) { "https://foo.com?wsdl" }
  let(:default_endpoint) { YieldStarClient::DEFAULT_ENDPOINT }
  let(:username) { 'test_user' }
  let(:password) { 'secret' }
  let(:namespace) { 'http://foo.com/namespace' }
  let(:client_name) { 'test_client' }
  let(:log) { true }
  let(:logger) { double() }
  let(:ssl_version) { double(:ssl_version) }

  it "has the correct settings" do
    expect(subject.endpoint).to eq endpoint
    expect(subject.username).to eq username
    expect(subject.password).to eq password
    expect(subject.namespace).to eq namespace
    expect(subject.client_name).to eq client_name
  end

  context 'delegates' do
    it { is_expected.to delegate_method(:endpoint).to(:configuration) }
    it { is_expected.to delegate_method(:username).to(:configuration) }
    it { is_expected.to delegate_method(:password).to(:configuration) }
    it { is_expected.to delegate_method(:namespace).to(:configuration) }
    it { is_expected.to delegate_method(:client_name).to(:configuration) }
    it { is_expected.to delegate_method(:log).to(:configuration) }
    it { is_expected.to delegate_method(:logger).to(:configuration) }
  end

  # Methods from the PropertyMethods mixin
  # The actual tests for these are in property_methods_spec
  # TODO: test mixins using shared example groups?
  # see: http://blog.davidchelimsky.net/2010/11/07/specifying-mixins-with-shared-example-groups-in-rspec-2/
  it { is_expected.to respond_to(:get_properties) }
  it { is_expected.to respond_to(:get_property) }
  it { is_expected.to respond_to(:get_property_parameters) }

  # Methods from the FloorPlanMethods mixin
  it { is_expected.to respond_to(:get_floor_plan) }
  it { is_expected.to respond_to(:get_floor_plans) }

  # Methods from UnitMethods
  it { is_expected.to respond_to(:get_unit) }
  it { is_expected.to respond_to(:get_units) }

  # Methods from AmenityMethods
  it { is_expected.to respond_to(:get_floor_plan_amenities) }
  it { is_expected.to respond_to(:get_unit_amenities) }

  # Methods from RentMethods
  it { is_expected.to respond_to(:get_rent_summary) }

  # Methods from LeaseTermRentMethods
  it { is_expected.to respond_to(:get_lease_term_rent) }

  context "with default configuration" do
    subject(:client) { YieldStarClient::Client.new }

    it "has the correct settings" do
      expect(client.endpoint).to eq default_endpoint
      expect(client.username).to be_blank
      expect(client.password).to be_blank
      expect(client.namespace).to eq YieldStarClient::DEFAULT_NAMESPACE
      expect(client.client_name).to be_blank
      expect(client.logger).to be_a Logger
    end
  end

  describe '#reset' do
    it 'set nil value to client_name' do
      expect { configuration.reset }.to change(subject, :client_name).to(nil)
    end

    it 'set DEFAULT_ENDPOINT value to endpoint' do
      expect { configuration.reset }.to change(subject, :endpoint).to(YieldStarClient::DEFAULT_ENDPOINT)
    end

    it 'set DEFAULT_NAMESPACE value to namespace' do
      expect { configuration.reset }.to change(subject, :namespace).to(YieldStarClient::DEFAULT_NAMESPACE)
    end

    it 'set DEFAULT_SSL_VERSION value to ssl_version' do
      expect { configuration.reset }.to change(subject, :ssl_version).to(YieldStarClient::DEFAULT_SSL_VERSION)
    end

    it 'set nil value to username' do
      expect { configuration.reset }.to change(subject, :username).to(nil)
    end

    it 'set nil value to password' do
      expect { configuration.reset }.to change(subject, :password).to(nil)
    end

    it 'set Logger value to logger' do
      expect { configuration.reset }.to change(subject, :logger)
    end

    it 'set false value to log' do
      expect { configuration.reset }.to change(subject, :log).to(false)
    end
  end
end
