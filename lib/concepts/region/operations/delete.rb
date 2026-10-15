class Region
  class Delete

    class << self
    def call(region_id)
      response = OperationResponse.new
      delete_region(region_id)
      response
    rescue StandardError => e
      Sentry.capture_exception(e)
      response[:error] = "Error deleting region: #{e.message}"
      response
    end

    def delete_region(region_id)
      region = Region.find(region_id)
      region.destroy!
    end
    end
  end
end