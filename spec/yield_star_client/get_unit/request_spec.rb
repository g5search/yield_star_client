require "spec_helper"

module YieldStarClient
  module GetUnit
    describe Request, type: :model do
      context "attributes" do
        subject { described_class }

        it { is_expected.to have_attribute(:external_property_id, String) }
        it { is_expected.to have_attribute(:unit, String) }
        it { is_expected.to have_attribute(:building, String) }
      end

      context "validations" do
        subject { described_class.new }

        it { is_expected.to validate_presence_of(:external_property_id) }
        it { is_expected.to validate_length_of(:external_property_id).is_at_most(50) }
        it { is_expected.to validate_presence_of(:unit) }
      end

      it "has the correct SOAP_ACTION" do
        expect(described_class::SOAP_ACTION).to eq :get_unit
      end
    end
  end
end
