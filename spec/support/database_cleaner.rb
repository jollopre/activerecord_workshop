require 'database_cleaner-active_record'

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end
  config.around(:each) do |example|
    if example.metadata[:skip_database_cleaner]
      example.run
    else
      DatabaseCleaner.cleaning do
        example.run
      end
    end
  end
end
