require 'json'
class PostSpiderWorker
  include Sidekiq::Worker
  include Sidekiq::Benchmark::Worker

  sidekiq_options :queue => 'default', :retry => false, :backtrace => true, expires_in: 1.hour

  def perform(record_id, record_klass)
    benchmark.meta_scraper_metric do
     case record_klass
      when "EmailLead"
        record = EmailLead.find(record_id)
      when "PhoneLead"
        record = PhoneLead.find(record_id)
      when "SocialLead"
        record = SocialLead.find(record_id)
      end

    if record and record.source_url
      meta = MetaInspector.new record.source_url
      if meta
        record.keywords =  meta.meta_tag['name']['keywords']
        record.description = meta.description
        record.image_url = meta.images.best
        record.save
      end
      end
    end
    benchmark.finish
   end
end