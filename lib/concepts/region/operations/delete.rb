# frozen_string_literal: true

#
class Region
  class Delete
    class << self
    def call(country:, region_id:)
      response = OperationResponse.new
      delete_region(country, region_id)
      response
    rescue ActiveRecord::RecordNotDestroyed => e
      response[:error] = "Error deleting region: #{e}"
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
