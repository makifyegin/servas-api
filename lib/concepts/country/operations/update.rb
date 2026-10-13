# frozen_string_literal: true

class Country
  class Update
    class << self
      def call(country:, country_params:)
        response = OperationResponse.new
        response[:country] = country
        response[:country].assign_attributes(country_params)
        response[:country].save!
        response
      rescue StandardError => e
        Sentry.capture_exception(e)
        response[:error] = "Error updating country: #{e}"
        response
      end
    end
  end
end
