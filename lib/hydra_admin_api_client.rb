require "faraday"
class HydraAdminApiClient
  HYDRA_ADMIN_API_URL = ENV.fetch("HYDRA_ADMIN_API_URL", "http://localhost:4445")


class << self
  def introspect(...)
    new.introspect(...)
  end

  def revoke_sessions(...)
    new.revoke_sessions(...)
  end
end

def introspect(token:)
  response = conn.post("admin/oauth2/introspect", token: token)
  response.body
end

# Revokes every consent (and with it every access and refresh token)
# and every login session of this subject, across all clients.
def revoke_sessions(subject:)
  conn.delete("admin/oauth2/auth/sessions/consent", subject:, all: true)
  conn.delete("admin/oauth2/auth/sessions/login", subject:)
  true
end


private

def conn
  @conn ||= Faraday.new(HYDRA_ADMIN_API_URL) do |f|
    f.request :url_encoded
    f.response :json
    f.response :raise_error
  end
end
end
