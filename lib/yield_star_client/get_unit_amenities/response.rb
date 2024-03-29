module YieldStarClient
  module GetUnitAmenities
    class Response < BaseResponse
      def amenities
        return @amenities if @amenities

        amenity_hashes = @soap_response
          .to_hash[:get_unit_amenities_response][:return][:amenity]
        amenity_hashes = [amenity_hashes].flatten.compact
        @amenities = amenity_hashes.map do |amenity_hash|
          Amenity.new(amenity_hash)
        end
      end
    end
  end
end
