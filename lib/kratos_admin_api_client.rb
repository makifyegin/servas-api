require "faraday"

class KratosAdminApiClient
  KRATOS_ADMIN_API_URL = ENV.fetch("KRATOS_ADMIN_API_URL", "http://localhost:4434")

  class << self
    def delete_identity(...)
      new.delete_identity(...)
    end
  end

  # Deleting an identity that is already gone counts as done,
  # so a retried delete does not fail.
  def delete_identity(id:)
    conn.delete("admin/identities/#{ERB::Util.url_encode(id)}")
    true
  rescue Faraday::ResourceNotFound
    true
  end

  private

  def conn
    @conn ||= Faraday.new(KRATOS_ADMIN_API_URL) do |f|
      f.response :json
      f.response :raise_error
    end
  end
end
