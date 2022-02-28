# frozen_string_literal: true

Jets.application.configure do
  config.project_name = 'myapp'
  config.mode = 'html'

  config.prewarm.enable = true # default is true
  config.prewarm.rate = '2 minutes' # default is '30 minutes'
  # config.prewarm.concurrency = 2 # default is 2
  # config.prewarm.rate = '30 minutes' # default is '30 minutes'
  # config.prewarm.concurrency = 2 # default is 2
  # config.prewarm.public_ratio = 3 # default is 3

  config.deploy.stagger.enabled = true

  ActiveRecord::Base.schema_format = :sql

  # config.env_extra = 2 # can also set this with JETS_ENV_EXTRA
  # config.autoload_paths = []

  # config.asset_base_url = 'https://cloudfront.domain.com/assets' # example

  # config.cors = true # for '*'' # defaults to false
  # config.cors = '*.mydomain.com' # for specific domain

  # config.function.timeout = 30 # defaults to 30
  # config.function.role = "arn:aws:iam::#{Jets.aws.account}:role/service-role/pre-created"
  # config.function.memory_size = 1536
  config.api.auto_replace = true
  # config.api.endpoint_type = 'PRIVATE' # Default is 'EDGE' (https://docs.aws.amazon.com/apigateway/api-reference/link-relation/restapi-create/#endpointConfiguration)

  # config.function.environment = {
  #   global_app_key1: "global_app_value1",
  #   global_app_key2: "global_app_value2",
  # }
  # More examples:
  # config.function.dead_letter_config = { target_arn: "arn" }
  # The config.function settings to the CloudFormation Lambda Function properties.
  # http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-lambda-function.html
  # Underscored format can be used for keys to make it look more ruby-ish.

  # Assets settings
  # The config.assets.folders are folders within the public folder that will be set
  # to public-read on s3 and served directly. IE: public/assets public/images public/packs
  # config.assets.folders = %w[assets images packs]
  # config.assets.max_age = 3600 # when to expire assets
  # config.assets.cache_control = nil # IE: "public, max-age=3600" # override max_age for more fine-grain control.
  # config.assets.base_url = nil # IE: https://cloudfront.com/my/base/path, defaults to the s3 bucket url
  #                                IE: https://s3-us-west-2.amazonaws.com/demo-dev-s3bucket-1inlzkvujq8zb

  # config.api.endpoint_type = 'PRIVATE' # Default is 'EDGE' https://amzn.to/2r0Iu2L
  # config.api.authorization_type = "AWS_IAM" # default is 'NONE' https://amzn.to/2qZ7zLh

  # More info: http://rubyonjets.com/docs/routing/custom-domain/
  # us-west-2 REGIONAL endpoint - takes 2 minutes
  if Jets.env.development?
    config.cors = ENV['CORS']
    config.domain.cert_arn = ENV['DOMAIN_CERT_ARN']
    config.domain.hosted_zone_name = ENV['DOMAIN_HOSTED_ZONE_NAME']
  elsif Jets.env.staging?
    config.cors = '*.staging.myapp.io'
  elsif Jets.env.production?
    config.cors = '*.myapp.io'
    config.session.options = {
      key:       'token',
      same_site: :lax,
      secure:    true
    }
  end

  # By default logger needs to log to $stderr for CloudWatch to receive Lambda messages, but for
  # local testing environment you may want to log these messages to 'test.log' file to keep your
  # testing suite output readable.
  config.logger = Jets::Logger.new($strerr) unless Jets.env.development? || Jets.env.test?
end
