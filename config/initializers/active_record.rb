require 'active_record'
require 'active_record/database_configurations'

primary = ActiveRecord::DatabaseConfigurations::HashConfig.new(
  ENV.fetch('APP_ENV'),
  "primary",
  {
    host: ENV.fetch('DB_HOST'),
    database: ENV.fetch('DB_NAME'),
    username: ENV.fetch('DB_USER'),
    password: ENV.fetch('DB_PASSWORD'),
    pool: ENV.fetch('DB_POOL_SIZE'),
    adapter: ENV.fetch('DB_ADAPTER')
  }
)
ActiveRecord::Base.configurations = [primary]
ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Base.establish_connection(ENV.fetch('APP_ENV').to_sym)
