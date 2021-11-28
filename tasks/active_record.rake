load 'active_record/railties/databases.rake'

task :environment do
  klass = ActiveRecord::Tasks::DatabaseTasks
  klass.env = ENV.fetch('APP_ENV')
  klass.database_configuration = ActiveRecord::Base.configurations
  klass.db_dir = 'db'
  klass.migrations_paths = "db/migrate"
  klass.root = ENV.fetch('APP')
  klass.seed_loader = Class.new do
    def load_seed
      load "db/seed.rb"
    end
  end.new
  klass.create_current(ENV.fetch('APP_ENV'))
end
