# frozen_string_literal: true

class Region
  class Update
    class << self
      def call(region:, region_params:)
        response = OperationResponse.new
        response[:region] = region
        response[:region].assign_attributes(region_params)
        response[:region].save!
        response
      rescue StandardError => e
        Sentry.capture_exception(e)
        response[:error] = "Error updating region: #{e}"
        response
      end
    end
  end
end
