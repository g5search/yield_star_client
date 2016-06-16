module YieldStarClient
  class Amenity
    include Virtus.model

    attribute :name
    attribute :type
    attribute :value, Float

  end
end
