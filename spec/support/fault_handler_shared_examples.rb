require "spec_helper"

shared_examples_for "a fault handler" do |soap_action|
  context "when there is an authentication fault" do
    before do
      savon.expects(soap_action).
        with(message: :any).
        returns(File.read("spec/fixtures/faults/authentication_fault.xml"))
      # raises_soap_fault.
      # returns(Savon::Spec::Fixture[:faults, :authentication_fault])
    end

    it "raises a YieldStarClient authentication error" do
      expect { subject }.to raise_error(YieldStarClient::AuthenticationError)
    end

    it "includes the fault message in the error object" do
      expect { subject }.to raise_error { |e| e.message.should == "Client [foo] not found for this user [12e7e719764-21c]" }
    end

    it "includes the fault code in the error object" do
      expect { subject }.to raise_error { |e| e.code.should == "12e7e719764-21c" }
    end
  end

  context "when there is an internal error fault" do
    before do
      savon.expects(soap_action).
        with(message: :any).
        returns(File.read("spec/fixtures/faults/internal_error_fault.xml"))
      # raises_soap_fault.
      # returns(Savon::Spec::Fixture[:faults, :internal_error_fault])
    end

    it "raises a YieldStarClient internal error" do
      expect { subject }.to raise_error(YieldStarClient::InternalError)
    end

    it "includes the fault message in the error object" do
      expect { subject }.to raise_error { |e| e.message.should == "Internal error [12e7cfbb782-37a]" }
    end

    it "includes the fault code in the error object" do
      expect { subject }.to raise_error { |e| e.code.should == "12e7cfbb782-37a" }
    end
  end

  context "when there is an operation fault" do
    before do
      savon.expects(soap_action).
        with(message: :any).
        returns(File.read("spec/fixtures/faults/operation_fault.xml"))
      # raises_soap_fault.
      # returns(Savon::Spec::Fixture[:faults, :operation_fault])
    end

    it "raises a YieldStarClient operation error" do
      expect { subject }.to raise_error(YieldStarClient::OperationError)
    end

    it "includes the fault message in the error object" do
      expect { subject }.to raise_error { |e| e.message.should == "Invalid floor plan name null [12e7e6acc24-1b]" }
    end

    it "includes the fault code in the error object" do
      expect { subject }.to raise_error { |e| e.code.should == "12e7e6acc24-1b" }
    end
  end

  context "when there is a generic fault" do
    before do
      savon.expects(soap_action).
        with(message: :any).
        returns(File.read("spec/fixtures/faults/generic_fault.xml"))
      # raises_soap_fault.
      # returns(Savon::Spec::Fixture[:faults, :generic_fault])
    end

    it "raises a YieldStarClient server error" do
      expect { subject }.to raise_error(YieldStarClient::ServerError)
    end

    it "includes the fault message in the error object" do
      expect { subject }.to raise_error { |e| e.message.should == "java.lang.NullPointerException" }
    end

    it "includes the fault code in the error object" do
      expect { subject }.to raise_error { |e| e.code.should == "S:Server" }
    end
  end
end
