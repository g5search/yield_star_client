require 'spec_helper'

module YieldStarClient
  RSpec.describe FloorPlan do

    describe "#id" do
      it "is a hash of the external_property_id and name" do
        floor_plan = described_class.
          new(external_property_id: "ext_prop", name: "1b1b")

        expect(floor_plan.id).to eq Digest::SHA1.hexdigest('ext_prop-1b1b')
      end
    end

  end
end
