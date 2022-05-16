class SocialLead < ActiveRecord::Base

  validates_uniqueness_of :profile_url, scope: :user_id
  belongs_to :website #, :foreign_key => :domain, :primary_key => :domain
  belongs_to :user

  alias_attribute :display_name, :username
  alias_attribute :location, :state


  scope :by_user, lambda {|user| where(:user_id => user) }
  scope :by_domain, lambda {|domain| where(:domain => domain) }
  scope :is_facebook, lambda { where(:social_network => "facebook")}
  scope :is_pinterest, lambda { where(:social_network => "pinterest")}
  scope :is_twitter, lambda { where(:social_network => "twitter")}
  scope :is_linkedin, lambda { where(:social_network => "linkedin")}
  scope :is_instagram, lambda { where(:social_network => "instagram")}
  scope :is_pinterest, lambda { where(:social_network => "pinterest")}
  scope :is_google, lambda { where(:social_network => "google-plus")}
  scope :is_okcupid, lambda { where(:social_network => "okcupid")}
  scope :is_yelp, lambda { where(:social_network => "yelp")}
  scope :is_github, lambda { where(:social_network => "github")}
  scope :by_user_from_facebook, lambda {|user| where(:user_id => user, :social_network => "facebook") }
  scope :by_user_from_twitter, lambda {|user| where(:user_id => user, :social_network => "twitter") }
  scope :by_user_from_pinterest, lambda {|user| where(:user_id => user, :social_network => "pinterest") }
  scope :by_user_from_github, lambda {|user| where(:user_id => user, :social_network => "github") }
  scope :by_user_from_facebook, lambda {|user| where(:user_id => user, :social_network => "facebook") }
  scope :from_state, lambda {|state| where(:state => state) }
  scope :from_country, lambda {|country| where(:country => country) }
  scope :from_network, lambda {|network| where(:social_network => network) }
  scope :by_user_from_network, lambda {|user, network| where(:user_id => user, :social_network => network) }
  searchkick callbacks: :async # ,  word_start: [:username, :domain], suggest: [:username] #, wordnet: true

  # after_create :get_page_text
  after_create :linkedin_scraper


  def self.okcupid
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

  end

  def scrape_okc(usernames=[], user_id=1, filename="/home/ubuntu/users.txt")
    unless filename.blank?
      file = File.open(filename, "rb")
      file.each_line do |line|
        usernames << line
      end
    end

    usernames.each do |username|
      profile = SocialLead.new(:user_id => user_id, :social_network => "okcupid",
                             :username=> username,
                             :profile_url => "https://2-instant.okcupid.com/profile/#{username}",
                             :source_url => "https://2-instant.okcupid.com/profile/#{username}")
      if profile.save
        ExtractWorker.perform_async("SocialLead", profile.id)
      end
    end

  end

  def display_name
    "#{self.social_network}: #{self.username}"
  end


  def get_page_text
    ExtractWorker.perform_async("SocialLead", self.id)
  end

  def tags
    self.keywords.delete("[").delete("]").delete('"')
  end

  def icon
    "hashtag"
  end

  def match_type
    "social media profile"
  end

  def event_name
    ["discovered on ", self.social_network].join
  end

  def ux_color
    "purple"
  end


  def linkedin_scraper
    if self.social_network == "linkedin" and Rails.env.production?
      LinkedinWorker.perform_async(self.id)
    end
  end

  def fa_icon
    self.social_network
  end

  def index_path
    "/social_leads"
  end


  def username
   self.profile_url.split("/").last.downcase
  end

  def score
    missing = self.attributes.values.select(&:nil?).count
    total = self.attributes.count
    (((total.to_f - missing.to_f) / total.to_f) * 100).round(1)
  end

  def color
    "purple"
  end

  def self.to_csv(options = {})
    csv_string = CSV.generate(options) do |csv|
      csv << ["Username", "Social Network", "Tags", "Source", "Date"]
      all.each do |record|
        csv << [record.username, record.social_network, record.keywords, record.domain, record.created_at.to_date]
      end
    end
    csv_string
  end


end
