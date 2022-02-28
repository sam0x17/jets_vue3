# frozen_string_literal: true

Jets.application.configure do
  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  # Docs: http://rubyonjets.com/docs/email-sending/
  config.action_mailer.delivery_method = :test
  config.logger = Logger.new($stdout)
  config.logger.level = Logger::INFO # NOTE: replace ERROR with INFO for more verbosity
end
