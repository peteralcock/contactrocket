require "tika/app"
class BulkExtractWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker
  include Sidekiq::Benchmark::Worker

  sidekiq_options :queue => 'default', :retry => false, :backtrace => true, expires_in: 1.hour

  def perform(source_urls=[], user_id)
    benchmark.bulk_extraction_metric do
      total source_urls.count
      source_urls.each do |src_url|
        social_records = SocialLead.where(:user_id => user_id, :source_url => src_url)
        phone_records = PhoneLead.where(:user_id => user_id, :source_url => src_url)
        email_records = EmailLead.where(:user_id => user_id, :source_url => src_url)
        records = [social_records,phone_records,email_records].flatten
        if records
          resource = Tika::Resource.new(src_url)
          if resource and resource.text
            counter = 0
             records.each do |record|
               counter += 1
               at counter, ">> #{record.source_url}"
               record.update(:page_text => resource.text)
            end
          end
        end
      end
    end
    benchmark.finish
  end
end







