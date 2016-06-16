require "spec_helper"

module YieldStarClient
  describe Unit do
    describe ".new" do
      let(:hash) do
        {
          bed_rooms: 1.0,
          bath_rooms: 2.0,
          square_footage: 3
        }
      end
      let(:unit) { Unit.new(hash) }

      it "remaps some keys" do
        expect(unit.bedrooms).to eql 1.0
        expect(unit.bathrooms).to eql 2.0
        expect(unit.square_feet).to eql 3
      end

    end

  end
end
