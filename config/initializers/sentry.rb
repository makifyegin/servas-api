Sentry.init do |config|
  config.dsn = ENV.fetch("SENTRY_DSN", nil)
  config.breadcrumbs_logger = [ :active_support_logger, :http_logger ]
  config.environment = Rails.env
  # Add data like request headers and IP for users,
  # see https://docs.sentry.io/platforms/ruby/data-management/data-collected/ for more info
  config.send_default_pii = Rails.env.development?

  # Enable sending logs to Sentry
  # config.enable_logs = true
  # Patch Ruby logger to forward logs
  config.enabled_patches = [ :logger ]
  config.rails.register_error_subscriber = true
  # Set profiles_sample_rate to profile 100%
  # of sampled transactions.
  # We recommend adjusting this value in production.
  config.profiles_sample_rate = 1.0
end