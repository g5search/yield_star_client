require 'spec_helper'

module YieldStarClient
  describe RentSummary do

    describe 'attributes' do
      let(:init_hash) do
        {
          effective_date: Date.new(2015, 1, 1),
          external_property_id: 'external_property_id',
          floor_plan_name: 'floor_plan_name',
          unit_type: '3.5x2',
          bed_rooms: 5.0,
          bath_rooms: 2.5,
          avg_square_feet: 100,
          min_market_rent: 300,
          max_market_rent: 400,
          concession_type: 'concession_type',
          min_concession: 1,
          max_concession: 2,
          min_final_rent: 350,
          max_final_rent: 450,
          floor_plan_description: 'floor_plan_description',
        }
      end

      subject { described_class.new(init_hash) }

      its(:external_property_id) { should == 'external_property_id' }
      its(:effective_date) { should == Date.new(2015, 1, 1) }
      its(:floor_plan_name) { should == 'floor_plan_name' }
      its(:unit_type) { should == '3.5x2' }
      its(:bedrooms) { should == 5.0 }
      its(:bathrooms) { should == 2.5 }
      its(:avg_square_feet) { should == 100 }
      its(:min_market_rent) { should == 300 }
      its(:max_market_rent) { should == 400 }
      its(:min_concession) { should == 1 }
      its(:max_concession) { should == 2 }
      its(:min_final_rent) { should == 350 }
      its(:max_final_rent) { should == 450 }
    end

  end
end
