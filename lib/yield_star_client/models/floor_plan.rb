module YieldStarClient

  # Represents a floor plan in the YieldStar system.
  #
  # A floor plan is guaranteed to have an +external_property_id+ and +name+. All other attributes are
  # optional.
  #
  # @attr [String] external_property_id the property ID of this floor plan
  # @attr [String] name the name of this floor plan
  # @attr [String] description the description of this floor plan
  # @attr [Integer] square_feet the average square footage of this floor plan
  # @attr [Integer] unit_count the number of units with this floor plan
  # @attr [Float] bedrooms the bedroom count of the floor plan
  # @attr [Float] bathrooms the bathroom count of the floor plan
  class FloorPlan
    include Virtus.model

    attribute :external_property_id
    attribute :name
    attribute :description
    attribute :square_feet, Integer, :from => :square_footage
    attribute :unit_count, Integer
    attribute :bedrooms, Float, :from => :bed_rooms
    attribute :bathrooms, Float, :from => :bath_rooms

    def self.new(attributes)
      attributes[:square_feet] = attributes.delete :square_footage
      attributes[:bed_rooms] = attributes.delete :bedrooms
      attributes[:bathrooms] = attributes.delete :bath_rooms

      super(attributes)
    end

  end
end
