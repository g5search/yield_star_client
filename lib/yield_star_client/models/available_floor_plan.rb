module YieldStarClient

  # Represents a floor plan with available units.
  #
  # @attr [String] external_property_id the ID of the property associated with the
  #                                     floor plan
  # @attr [Date] effective_date the date that all listed prices are considered effective
  # @attr [String] floor_plan_name the name of the floor plan that matches the
  #                                Price Optimizer dashboard
  # @attr [Array<AvailableUnit>] units the available unit data associated with this
  #                                    floor plan
  # @attr [Float] bedrooms the number of bedrooms in this floor plan
  # @attr [Float] bathrooms the number of bathrooms in this floor plan
  # @attr [Integer] square_feet the square footage of the floor plan
  class AvailableFloorPlan
    include Virtus.model

    attribute :external_property_id
    attribute :effective_date, Date
    attribute :floor_plan_name
    attribute :bedrooms, Float
    attribute :bathrooms, Float
    attribute :square_feet, Integer
    attribute :units, Array

    def self.new(attributes={})
      attributes[:units] = [attributes.delete(:unit)].flatten.compact.map do |unit|
                             AvailableUnit.new(unit)
                           end
      attributes[:bedrooms] = attributes.delete :bed_rooms
      attributes[:bathrooms] = attributes.delete :bath_rooms
      attributes[:square_feet] = attributes.delete :sq_ft

      super(attributes)
    end

    def id
      floor_plan_name
    end

  end

end
