require "tika/app"
class ExtractWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker
  include Sidekiq::Benchmark::Worker

  sidekiq_options :queue => 'default', :retry => false, :backtrace => true #, expires_in: 1.hour

  def perform(klass, id)

  end
end







