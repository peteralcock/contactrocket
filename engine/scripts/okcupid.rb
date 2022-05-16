file = File.open("/home/ubuntu/users.txt", "rb")
file.each_line do |line|
social = SocialLead.new(:username => line, 
:profile_url => "https://2-instant.okcupid.com/profile/#{line}", 
:source_url => "https://2-instant.okcupid.com/profile/#{line}", 
:social_network => "okcupid", :user_id => 1)
 if social.save
 puts social.id
 ExtractWorker.perform_async("SocialLead", social.id)
 end
end
