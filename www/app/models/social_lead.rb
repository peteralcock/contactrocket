class SocialLead < ActiveRecord::Base
  # include SpreadsheetArchitect
  acts_as_paranoid
  validates_uniqueness_of :profile_url, scope: :user_id
  belongs_to :website #, :foreign_key => :domain, :primary_key => :domain
  belongs_to :user
  has_one :crm_user, :through => :user

  alias_attribute :display_name, :username
  alias_attribute :location, :state

  attr_accessible   :user_id, :keywords, :smart_tags,  :data_hash, :company_id, :is_valid, :website_id, :source_url, :domain, :original_url, :email_address,
                    :name, :social_network, :profile_url, :country, :city, :street, :address, :state, :website, :first_name, :last_name, :username

  # after_save :linkedin_scraper
  scope :by_user, lambda {|user| where(:user_id => user) }
  scope :created_by_user, lambda {|user_id| where(:user_id => user_id) }

  scope :by_domain, lambda {|domain| where(:domain => domain) }
  scope :is_facebook, lambda { where(:social_network => "facebook")}
  scope :is_pinterest, lambda { where(:social_network => "pinterest")}
  scope :is_twitter, lambda { where(:social_network => "twitter")}
  scope :is_linkedin, lambda { where(:social_network => "linkedin")}
  scope :is_instagram, lambda { where(:social_network => "instagram")}
  scope :is_okcupid, lambda { where(:social_network => "okcupid")}
  scope :is_pinterest, lambda { where(:social_network => "pinterest")}
  scope :is_google, lambda { where(:social_network => "google-plus")}
  scope :is_yelp, lambda { where(:social_network => "yelp")}
  scope :is_github, lambda { where(:social_network => "github")}
  scope :by_user_from_facebook, lambda {|user| where(:user_id => user, :social_network => "facebook") }
  scope :by_user_from_twitter, lambda {|user| where(:user_id => user, :social_network => "twitter") }
  scope :by_user_from_pinterest, lambda {|user| where(:user_id => user, :social_network => "pinterest") }
  scope :by_user_from_github, lambda {|user| where(:user_id => user, :social_network => "github") }
  scope :by_user_from_facebook, lambda {|user| where(:user_id => user, :social_network => "facebook") }
  scope :by_user_from_facebook, lambda {|user| where(:user_id => user, :social_network => "facebook") }
  scope :from_state, lambda {|state| where(:state => state) }
  scope :from_country, lambda {|country| where(:country => country) }
  scope :from_network, lambda {|network| where(:social_network => network) }
  scope :by_user_from_network, lambda {|user, network| where(:user_id => user, :social_network => network) }
  searchkick callbacks: :async #,  word_start: [:username, :domain], suggest: [:username] #, wordnet: true

  def self.scrape_okc(usernames=[], user_id=10, filename="users.txt")
    unless filename.blank?
      file = File.open(filename, "rb")
      file.each_line do |line|
        usernames << line
      end
    end

    usernames.each do |username|
      profile = SocialLead.new(:user_id => 10, :social_network => "okcupid",
                               :username=> username,
                               :profile_url => "https://2-instant.okcupid.com/profile/#{username}",
                               :source_url => "https://2-instant.okcupid.com/profile/#{username}")
      profile.save
    end

  end






  def get_page_text
    resource = Tika::Resource.new(self.source_url)
    if resource
      text = resource.text
      if text
        self.page_text = text
        self.save
      end
    end
  end


  def word_count
    counter = WordsCounted.count(self.keywords.to_s)
    counter.token_frequency
    # counter.most_frequent_tokens
  end


  def new_record?
    self.id.nil?
  end


  def crm_id
    self.user_id
  end

  def add_to_crm

  if  self.user.subscription and Apartment::Tenant.switch!(self.user.username)
    lead = Lead.new
    lead.rating = 0
    lead.do_not_call = false
    lead.created_at = Time.now
    lead.updated_at = Time.now
    lead.access = "Private"
    lead.user_id =  self.crm_id
    lead.assigned_to =   self.crm_id
    lead.first_name = "#{self.username} (#{self.social_network.to_s.humanize})"
    lead.last_name = self.domain
    lead.background_info = self.tags.to_s
    if self.social_network == "facebook"
      lead.facebook = self.profile_url
    elsif self.social_network == "twitter"
      lead.twitter = self.profile_url
    elsif self.social_network == "linkedin"
      lead.linkedin = self.profile_url
    end

    lead.save
    end
 # end

  end

  def social_network_color
    key = self.social_network.to_sym
    $social_network_colors[key]
  end

  
  def tags
    self.keywords.to_s.delete("[").delete("]").delete('"')
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
    CSV.generate(options) do |csv|
      csv << ["Username", "Social Network", "Tags", "Source", "Date"]
      all.each do |record|
        csv << [record.username, record.social_network, record.keywords, record.domain, record.created_at.to_date]
      end
    end
  end


end
