   #
   #  DatabaseCleaner.logger = Rails.logger
   #  RSpec.configure do |config|
   #    config.use_transactional_fixtures = false
   #    config.before(:suite) do
   #    #  DatabaseCleaner.strategy = :truncation, {:only => %w[users email_leads phone_leads social_leads people websites]}
   #    #  DatabaseCleaner.clean
   #      Sidekiq::Queue.new.clear
   #      Sidekiq::RetrySet.new.clear
   #    end
   # end
   #




