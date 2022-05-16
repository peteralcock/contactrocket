class LeadWorker
  include Sidekiq::Worker
  include Sidekiq::Benchmark::Worker
  sidekiq_options :queue => 'default', :retry => false, :backtrace => true# , expires_in: 3.days

  def perform(addresses, numbers, profiles, user_id, website_id, domain)
    unless addresses.blank? and numbers.blank? and profiles.blank?
      source_urls = []

      if profiles
        profiles.each do |profile|
          source_urls << profile[1]
        end

        social_batch = Sidekiq::Batch.new
        social_batch.description =  "user_#{user_id}__#{domain}_social_leads"
        benchmark.social_batch_jobs_metric do
          social_batch.jobs do
          profiles.each do |profile|
            username = profile[0].split("/").last
            if profile[0].match("google")
              network = "google-plus"
            end
            network ||= profile[0].split("//").last.split(".com").first
            new_social =  SocialLead.create(:website_id => website_id,
                                            :social_network => network,
                                            :username => username,
                                            :profile_url => profile[0],
                                            :source_url => profile[1],
                                            :user_id => user_id,
                                            :domain => domain)
            if new_social and new_social.id
              PostSpiderWorker.perform_async(new_social.id, "SocialLead")
              TextAnalysisWorker.perform_async("SocialLead", new_social.id)
            end
          end
        end
        end

      end
      if numbers
        numbers.each do |num|
          source_urls << num[1]
        end
        phone_batch = Sidekiq::Batch.new
        phone_batch.description =  "user_#{user_id}__#{domain}_phone_leads"
        benchmark.phone_batch_jobs_metric do
          phone_batch.jobs do
          numbers.each do |number|
            new_phone = PhoneLead.create(:number => number[0],
                                         :website_id => website_id,
                                         :user_id => user_id,
                                         :domain => domain,
                                         :source_url => number[1])
            if new_phone and new_phone.id
              PostSpiderWorker.perform_async(new_phone.id, "PhoneLead")
              TextAnalysisWorker.perform_async("PhoneLead", new_phone.id)
            end
          end
          end
        end

      end
      if addresses
        addresses.each do |address|
          source_urls << address[1]
        end
        address_batch = Sidekiq::Batch.new
        address_batch.description = "user_#{user_id}_#{domain}__email_leads"
        benchmark.email_batch_jobs_metric do
          address_batch.jobs do
          addresses.each do |address|
            new_email = EmailLead.create(:website_id => website_id,
                                         :address => address[0],
                                         :user_id => user_id,
                                         :source_url => address[1],
                                         :domain => domain)
            if new_email and new_email.id
              PostSpiderWorker.perform_async(new_email.id, "EmailLead")
              TextAnalysisWorker.perform_async("EmailLead", new_email.id)
            end
          end
          end
        end
      end
      source_urls.uniq!
      BulkExtractWorker.perform_async(source_urls, user_id)
      benchmark.finish
    end
  end
end
