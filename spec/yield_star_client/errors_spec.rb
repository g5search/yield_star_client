require "spec_helper"

describe YieldStarClient::ServerError do
  subject { error }

  let(:error) { YieldStarClient::ServerError.new(message, code) }
  let(:code) { "my code" }
  let(:message) { "my message" }

  context "default initialization" do
    let(:error) { YieldStarClient::ServerError.new }

    it { is_expected.to respond_to(:code) }

    it "does not have a code" do
      expect(subject.code).to be_blank
    end

    it { is_expected.to respond_to(:message) }

    it "has the correct message" do
      expect(subject.message).to eq error.class.name
    end
  end

  context "message initialization" do
    let(:error) { YieldStarClient::ServerError.new(message) }

    it "does not have a code" do
      expect(subject.code).to be_blank
    end

    it "has the correct message" do
      expect(subject.message).to eq message
    end
  end

  context "full initialization" do
    it "has a code" do
      expect(subject.code).to eq code
    end

    it "has the correct message" do
      expect(subject.message).to eq message
    end
  end

  describe "#to_s" do
    subject { error.to_s }

    context "when there is a message" do
      it { is_expected.to match(message) }
    end

    context "when there isn't a message" do
      let(:message) { nil }

      it { is_expected.to match(error.class.name) }
    end
  end

  describe ".translate_fault" do
    subject { YieldStarClient::ServerError.translate_fault(fault) }

    context "on Savon::SOAPFault error" do
      let(:fault) do
        double(
          Savon::SOAPFault,
          to_hash: {
            fault: {
              faultstring: faultstring,
              faultcode: faultcode,
              detail: {
                fault_type => {
                  message: faultstring,
                  code: faultcode,
                },
              },
            },
          },
        )
      end

      before do
        allow(fault).to receive(:instance_of?).with(Savon::HTTPError).and_return false
        allow(fault).to receive(:instance_of?).with(Savon::SOAPFault).and_return true
      end

      context "for an authentication fault" do
        # let(:response) { mock() { stubs(:body).returns(Savon::Spec::Fixture[:faults, :authentication_fault]) } }
        let(:faultstring) { "Client [foo] not found for this user [12e7e719764-21c]"}
        let(:faultcode) { "12e7e719764-21c" }
        let(:fault_type) { :authentication_fault }

        it { is_expected.to be_a YieldStarClient::AuthenticationError }

        it "has the correct message" do
          expect(subject.message).to eq faultstring
        end

        it "has the correct code" do
          expect(subject.code).to eq faultcode
        end
      end

      context "for an internal error fault" do
        let(:faultstring) {"Internal error [12e7cfbb782-37a]"}
        let(:faultcode) { "12e7cfbb782-37a" }
        let(:fault_type) { :internal_error_fault }

        it { is_expected.to be_a YieldStarClient::InternalError }

        it "has the correct message" do
          expect(subject.message).to eq faultstring
        end

        it "has the correct message" do
          expect(subject.code).to eq faultcode
        end
      end

      context "for an operation fault" do
        let(:faultstring) {"Internal error [12e7cfbb782-37a]"}
        let(:faultcode) { "12e7cfbb782-37a" }
        let(:fault_type) { :operation_fault }

        it { is_expected.to be_a YieldStarClient::OperationError }

        it "has the correct message" do
          expect(subject.message).to eq faultstring
        end

        it "has the correct code" do
          expect(subject.code).to eq faultcode
        end
      end

      context "for a generic fault" do
        let(:faultstring) {"java.lang.NullPointerException"}
        let(:faultcode) { "S:Server" }
        let(:fault_type) { :operation_fault }

        it { is_expected.to be_a YieldStarClient::ServerError }

        it "has the correct message" do
          expect(subject.message).to eq faultstring
        end

        it "has the correct code" do
          expect(subject.code).to eq faultcode
        end
      end
    end

    context "on Savon::HTTPError error" do
      let(:fault) do
        double(
          Savon::HTTPError,
          to_hash: {
            code: 401,
            message: "Username and password are wrong",
          },
        )
      end

      context "for an authentication fault" do
        let(:fault_type) { :authentication_fault }

        it "has the correct message" do
          allow(fault).to receive(:instance_of?).with(Savon::HTTPError).and_return true
          expect(subject.message).to eq "Authentication Error"
          expect(subject).to be_a YieldStarClient::AuthenticationError
        end
      end
    end
  end
end

describe YieldStarClient::AuthenticationError do
  it { is_expected.to be }
end

describe YieldStarClient::InternalError do
  it { is_expected.to be }
end

describe YieldStarClient::OperationError do
  it { is_expected.to be }
end
