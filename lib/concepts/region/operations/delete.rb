# frozen_string_literal: true

#
class Region
  class Delete
    class << self
    def call(country:, region_id:)
      response = OperationResponse.new
      delete_region(country, region_id)
      response
    rescue StandardError => e
      Sentry.capture_exception(e)
      response[:error] = "Error deleting region: #{e.message}"
      response
    end


    private
    def delete_region(country, region_id)
      region = country.regions.find(region_id)
      region.destroy!
    end
    end
  end
end
