# frozen_string_literal: true

class Country
  class Delete
    class << self
      def call(country_id:)
        response = OperationResponse.new
        delete_country(country_id)
        response
      rescue StandardError => e
        Sentry.capture_exception(e)
        response[:error] = "Error deleting country: #{e}"
        response
      end

      private

      def delete_country(country_id)
        country = Country.find(country_id)
        country.destroy!
      end
    end
  end
end
