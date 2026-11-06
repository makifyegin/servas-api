# frozen_string_literal: true

class Region
  class Create
    class << self
      def call(country:, region_params:)
        response = OperationResponse.new
        response[:region] = build_region(country:, region_params:)
        response[:region].save!
        response
      rescue ActiveRecord::RecordInvalid => invalid
        response[:error] = invalid.message
        response
      end

      private

      def build_region(country:, region_params:)
        country.regions.build(region_params)
      end
    end
  end
end