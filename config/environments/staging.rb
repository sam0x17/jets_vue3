# frozen_string_literal: true

Jets.application.configure do
  # Example:
  # config.function.memory_size = 1536
  # config.domain.hosted_zone_name = staging.myapp.io
  # config.action_mailer.raise_delivery_errors = false
  # Docs: http://rubyonjets.com/docs/email-sending/
  # config.iam_policy = ["s3"]
  # config.s3_event.configure_bucket = true # true by default
  # config.s3_event.notification_configuration = {
  #   topic_configurations: [
  #     {
  #       events:    [
  #         's3:ObjectCreated:*',
  #         's3:PutBucketNotification'
  #       ], # default: s3:ObjectCreated:*
  #       topic_arn: '!Ref SnsTopic' # must use this logical id, dont change
  #       # custom filter rule, by default there is no filter
  #       # filter: {
  #       #   key: {
  #       #     filter_rules: [
  #       #       {
  #       #         name: "prefix",
  #       #         value: "images/",
  #       #       },
  #       #       {
  #       #         name: "suffix",
  #       #         value: ".png",
  #       #       }
  #       #     ] # filter_rules
  #       #   } # key
  #       # } # filter
  #     }
  #   ]
  # }
end
