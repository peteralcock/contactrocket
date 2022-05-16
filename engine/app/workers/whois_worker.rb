class WhoisWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker # Important!
  include Sidekiq::Benchmark::Worker
  sidekiq_options :retry => false, :backtrace => true,  expires_in: 1.hour

  def perform(domain)
    benchmark.whois_metric do
    website = Website.find_by(:domain => domain)
    if website and Rails.env.production?
      whois_data = Whois.whois(website.domain)
      if whois_data and whois_data.contacts
        contacts = whois_data.contacts
        unless contacts.blank?
          contacts.each do |contact|
            if contact.organization
            company = Company.find_or_initialize_by(:company_name => contact.organization, :domain => website.domain)
            unless company.id
              company.address  = contact.address
              company.city = contact.city
              company.state = contact.state
              company.country = contact.country
              if company.save
                website.company_id = company.id
              end
            end
            if contact.name
              name_array = contact.name.split(" ")
              person = Person.find_or_initialize_by(:first_name => name_array.first, :last_name => name_array.last, :domain => website.domain)
              unless person.id
                person.company_id = company.id
                person.save
              end
            end
         end
        end
        end
        website.whois = whois_data.to_s
        website.save
      end
    end
  end
  benchmark.finish

  end

end


