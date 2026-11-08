# frozen_string_literal: true

require "rspec/openapi"

RSpec::OpenAPI.path = "swagger/v1/openapi.yaml"
RSpec::OpenAPI.title = "Servas API"
RSpec::OpenAPI.openapi_version = "3.1.0"
RSpec::OpenAPI.servers = [ { url: "http://localhost:3001" } ]
RSpec::OpenAPI.security_schemes = {
  "bearer_auth" => { type: "http", scheme: "bearer" }
}

# Remove the "Api::" prefix from tags: Api::Country -> Country
RSpec::OpenAPI.post_process_hook = ->(_path, _records, spec) do
  paths = spec["paths"] || spec[:paths] || {}
  paths.each_value do |operations|
    operations.each_value do |op|
      next unless op.is_a?(Hash)
      key = op.key?("tags") ? "tags" : :tags
      op[key] = op[key].map { |t| t.to_s.delete_prefix("Api::") } if op[key]
    end
  end
end