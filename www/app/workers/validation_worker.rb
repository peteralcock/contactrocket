class ValidationWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker # Important!
  include Sidekiq::Benchmark::Worker
  sidekiq_options   :queue => 'validation', :retry => false, :backtrace => true #, expires_in: 3.days

  def perform(email_address, user_id)

  end


end


