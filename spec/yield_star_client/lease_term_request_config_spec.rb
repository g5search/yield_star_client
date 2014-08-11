require "spec_helper"

module YieldStarClient
  describe LeaseTermRequestConfig do
    let(:fake_request_class) do
      FakeRequestClass = Class.new(BaseRequest) do
        configure_for_lease_term_rent request_element: :sample_request_element
      end
    end

    context "attributes" do
      subject { fake_request_class }
      it { is_expected.to have_attribute(:external_property_id, String) }
      it { is_expected.to have_attribute(:unit_number, String) }
    end

    context "validations" do
      subject { fake_request_class.new }
      it { is_expected.to validate_presence_of(:external_property_id) }
      it { is_expected.to validate_presence_of(:unit_number) }
    end

    it "defines request_args" do
      request = fake_request_class.new(unit_number: "unit_number")

      rent_options = double(
        to_request_hash: { rent_options: "rent_options" }
      )
      allow(LeaseTermRentOptions).to receive(:new).
        with(unit_number: "unit_number").and_return(rent_options)

      expected_args = {
        unit_number: "unit_number",
        sample_request_element: {
          rent_options: "rent_options"
        }
      }

      expect(request.request_args).to include(expected_args)
    end
  end
end