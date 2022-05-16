require "tika/app"
class ExtractWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker
  include Sidekiq::Benchmark::Worker

  sidekiq_options :queue => 'default', :retry => false, :backtrace => true, expires_in: 1.hour

  def perform(klass, id)
    benchmark.extraction_metric do
      if klass == "EmailLead"
        record = EmailLead.find(id)
      elsif klass == "PhoneLead"
        record = PhoneLead.find(id)
      elsif klass == "SocialLead"
        record = SocialLead.find(id)
      end

      if record
        resource = Tika::Resource.new(record.source_url)
        if resource
          text = resource.text
          if text
            record.update(:page_text => text)
          end
        end
      end
    end
    benchmark.finish
  end
end







