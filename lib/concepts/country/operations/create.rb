# frozen_string_literal: true

class Country
  class Create
    class << self
      def call(country_params:)
        response = OperationResponse.new
        response[:country] = create_country(country_params:)
        response[:country].save!
        response
      rescue StandardError => e
        Sentry.capture_exception(e)
        response[:error] = "Error creating country: #{e}"
        response
      end

      private

      def create_country(country_params:)
        Country.new(country_params)
      end
    end
  end
end
