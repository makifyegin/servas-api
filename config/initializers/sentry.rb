# frozen_string_literal: true

Sentry.init do |config|
  config.dsn = ENV.fetch("SENTRY_DSN", nil) if Rails.env.production?
  config.environment = Rails.env
end