require 'active_record'
require 'active_record/database_configurations'

primary = ActiveRecord::DatabaseConfigurations::HashConfig.new(
  ENV.fetch('APP_ENV'),
  "primary",
  {
    host: ENV.fetch('DB_HOST'),
    database: ENV.fetch('MYSQL_DATABASE'),
    username: ENV.fetch('MYSQL_USER'),
    password: ENV.fetch('MYSQL_PASSWORD'),
    pool: ENV.fetch('DB_POOL_SIZE'),
    adapter: ENV.fetch('DB_ADAPTER')
  }
)
ActiveRecord::Base.configurations = [primary]
ActiveRecord::Base.logger = Logger.new(STDOUT)
