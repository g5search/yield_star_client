require 'spec_helper'

describe "amenity methods" do
  subject { test_object } 
  let(:test_object) { YieldStarClient::Client.new(:endpoint => 'http://bogusendpoint', :client_name => client_name) }

  let(:client_name) { 'my_client_name' }
  let(:external_property_id) { 'my_prop_id' }

  it { should respond_to(:get_floor_plan_amenities) }
  it { should respond_to(:get_unit_amenities) }

  describe "#get_floor_plan_amenities" do
    before { savon.stubs(:get_floor_plan_amenities).returns(nil) }

    subject { amenities }
    let(:amenities) { test_object.get_floor_plan_amenities(external_property_id, floor_plan_name) }
    let(:floor_plan_name) { 'my_floor_plan' }

    it "should retrieve the amenity data from the service" do
      soap_body = {:client_name => client_name, 
                   :external_property_id => external_property_id, 
                   :floor_plan_name => floor_plan_name}
      savon.expects(:get_floor_plan_amenities).with(:request => soap_body).returns(:no_amenities)
      subject.should be
    end

    context "with no amenities" do
      before { savon.stubs(:get_floor_plan_amenities).returns(:no_amenities) }

      it { should be }
      it { should be_empty }
    end

    context "with a single amenity" do
      before { savon.stubs(:get_floor_plan_amenities).returns(:single_amenity) }

      it "has 1 amenity" do
        expect(subject.size).to eq 1
      end

      describe "first amenity" do
        subject { amenities.first }

        it "is the correct amenity" do
          expect(subject.name).to eq 'Garage Spot'
          expect(subject.type).to eq 'Parking'
        end
      end
    end

    context "with multiple amenities" do
      before { savon.stubs(:get_floor_plan_amenities).returns(:multiple_amenities) }

      it "has 2 amenities" do
        expect(subject.size).to eq 2
      end

      describe "first amenity" do
        subject { amenities.first }
      end

      describe "last amenity" do
        subject { amenities.last }
      end
    end

    # Validations
    it_should_behave_like 'a client_name validator'
    it_should_behave_like 'an external_property_id validator'
    it_should_behave_like 'a required string validator', :floor_plan_name

    # Error handling
    it_should_behave_like 'a fault handler', :get_floor_plan_amenities
  end

  describe "#get_unit_amenities" do
    before { savon.stubs(:get_unit_amenities).returns(nil) }

    subject { amenities }

    let(:amenities) { test_object.get_unit_amenities(external_property_id, unit_name, building) }
    let(:unit_name) { 'my_unit_name' }
    let(:building) { 'my_building' }

    context "without a building" do
      let(:amenities) { test_object.get_unit_amenities(external_property_id, unit_name) }
      let(:soap_body) do 
        {:client_name => client_name, 
         :external_property_id => external_property_id, 
         :unit_name => unit_name}
      end

      it "should retrieve the data from the service" do
        savon.expects(:get_unit_amenities).with(:request => soap_body).returns(:no_amenities)
        subject.should be
      end
    end

    context "with a building" do
      let(:soap_body) do 
        {:client_name => client_name, 
         :external_property_id => external_property_id, 
         :unit_name => unit_name, 
         :building => building}
      end

      it "should retrieve the data from the service" do
        savon.expects(:get_unit_amenities).with(:request => soap_body).returns(:no_amenities)
        subject.should be
      end
    end

    context "when there are no amenities" do
      before { savon.stubs(:get_unit_amenities).returns(:no_amenities) }

      it { should be }
      it { should be_empty }
    end

    context "when there is one amenity" do
      before { savon.stubs(:get_unit_amenities).returns(:single_amenity) }

      it "has 1 amenity" do
        expect(subject.size).to eq 1
      end

      describe "first amenity" do
        subject { amenities.first }

        it "is the correct amenity" do
          expect(subject.name).to eq "2nd Floor"
          expect(subject.type).to eq "Fixed"
        end
      end
    end

    context "when there are multiple amenities" do
      before { savon.stubs(:get_unit_amenities).returns(:multiple_amenities) }

      describe "first amenity" do
        subject { amenities.first }

        it "is the correct amenity" do
          expect(subject.name).to eq 'Rent Adjustment'
          expect(subject.type).to eq 'Fixed'
          expect(subject.value).to eq 50.0
        end
      end

      describe "last amenity" do
        subject { amenities.last }

        it "is the correct amenity" do
          expect(subject.name).to eq 'Good Credit Adjustment'
          expect(subject.type).to eq 'Variable'
          expect(subject.value).to be_nil
        end
      end
    end

    # Validation
    it_should_behave_like 'a client_name validator'
    it_should_behave_like 'an external_property_id validator'
    it_should_behave_like 'a required string validator', :unit_name

    context "when there is no building" do
      before { savon.stubs(:get_unit_amenities).returns(:no_amenities) }
      let(:amenities) { test_object.get_unit_amenities(external_property_id, unit_name) }

      it "should not raise an error" do
        expect { subject }.to_not raise_error
      end
    end

    # Error handling
    it_should_behave_like 'a fault handler', :get_unit_amenities
  end
end
