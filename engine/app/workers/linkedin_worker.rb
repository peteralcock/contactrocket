class LinkedinWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false, :backtrace => true

  def perform(id)

    record = SocialLead.find(id)
    if record
    profile = Linkedin::Profile.new(record.profile_url) # , { company_details: true, open_timeout: 30, proxy_ip: '127.0.0.1', proxy_port: '3128', username: 'user', password: 'pass' })
      if profile
        record.first_name = profile.first_name          # The first name of the contact
        record.last_name = profile.last_name           # The last name of the contact
        record.description = profile.summary      # The summary of the profile
        record.location = profile.location            # The location of the contact
        record.country = profile.country             # The country of the contact
        record.image_url = profile.picture             # The profile picture link of profile
        record.name = profile.name

       # record.title = profile.title               # The full name of the profile


       # record.industry = profile.industry            # The domain for which the contact belongs
       # record.skills = profile.skills.to_s            # Array of skills of the profile
       #  record.organization = profile.organizations.to_s     # Array organizations of the profile
       # record.education = profile.education.to_s      # Array of hashes for education
       # record.websites = profile.websites.to_s         # Array of websites
       # record.interests = profile.groups.to_s              # Array of groups
       # record.followers = profile.number_of_connections # The number of connections as a string
        record.save

      end
    end


  end
end


