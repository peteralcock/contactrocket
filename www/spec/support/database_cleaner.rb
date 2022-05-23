
if ENV["CLEAN_DB"]
  DatabaseCleaner.logger = Rails.logger
  RSpec.configure do |config|
    config.use_transactional_fixtures = false
    config.before(:suite) do
      DatabaseCleaner.strategy = :truncation, {:only => %w[email_leads phone_leads social_leads people websites]}
      DatabaseCleaner.clean
      Sidekiq::Queue.new.clear
      Sidekiq::RetrySet.new.clear
    end
 end


RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, type: :feature) do
    driver_shares_db_connection_with_specs = Capybara.current_driver == :rack_test

    if !driver_shares_db_connection_with_specs
      DatabaseCleaner.strategy = :truncation
    end
  end

  config.before(:each, :truncation_mode) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

end
end
