class SpiderWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker # Important!
  sidekiq_options :queue => 'crawler', :retry => false, :backtrace => true # , expires_in: 3.days #, throttle: { threshold: 10, period: 1.minute, key: ->(user_id){ user_id } }

  def perform(url, user_id, job_id)

  end
end






