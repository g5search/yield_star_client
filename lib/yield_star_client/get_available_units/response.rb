module YieldStarClient
  module GetAvailableUnits
    class Response < BaseResponse

      def available_units
        return @available_units if @available_units
        available_floor_plan_hashes =
          extract_available_floor_plan_hashes_from(@soap_response.to_hash)
        @available_units = available_floor_plan_hashes.map do |hash|
          AvailableFloorPlan.new(hash)
        end
      end

      private

      def extract_available_floor_plan_hashes_from(soap_response)
        ExtractAvailableFloorPlanHashes.execute(soap_response)
      end

    end
  end
end
