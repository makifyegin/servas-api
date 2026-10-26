# frozen_string_literal: true

# Which websites may call this API from a browser (CORS). Like editor-api:
# - development/test: any localhost address
# - production: only the addresses in ENV["ALLOWED_ORIGINS"] (comma-separated)
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins(%r{https?://([a-z0-9-]+\.)?localhost([:0-9]*)$}) if Rails.env.development? || Rails.env.test?
    resource "/api/*", headers: :any, methods: %i[get post patch put delete]
  end

  allow do
    origins(*ENV.fetch("ALLOWED_ORIGINS", "").split(",").map(&:strip).reject(&:empty?))
    resource "/api/*", headers: :any, methods: %i[get post patch put delete]
  end
end