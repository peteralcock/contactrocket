class PhoneLead < ActiveRecord::Base
  # include SpreadsheetArchitect
  acts_as_paranoid
  validates_uniqueness_of :number, scope: :user_id

  alias_attribute :display_name, :better_number
  alias_attribute :location, :state
  alias_attribute :website, :original_url

  attr_accessible   :user_id, :keywords, :smart_tags, :data_hash, :in_crm, :is_personal, :is_company, :company_id, :state, :number_type, :website_id,
                   :source_url, :is_valid, :original_url, :number, :domain, :data_hash, :location, :state, :country, :source_url

  # serialize :tag_blob, HashSerializer
  scope :from_state, lambda {|state| where(:state => state) }
  scope :from_country, lambda {|country| where(:country => country) }
  scope :by_user, lambda {|user| where(:user_id => user) }
  scope :created_by_user, lambda {|user_id| where(:user_id => user_id) }
  scope :has_location, lambda {where.not(:location => nil)}

  scope :by_domain, lambda {|domain| where(:domain => domain) }
  after_validation :geotag, :if => :new_record?
  # validates :number, phony_plausible: true

  belongs_to :user
  has_one :crm_user, :through => :user
  belongs_to :website #, :foreign_key => :domain, :primary_key => :domain

  searchkick callbacks: :async # ,  word_start: [:number, :domain], suggest: [:domain] #, wordnet: true



  def word_count
    counter = WordsCounted.count(self.keywords.to_s)
    counter.token_frequency
    # counter.most_frequent_tokens
  end


  def get_page_text
    resource = Tika::Resource.new(self.source_url)
    if resource and resource.text
      text = resource.text
      if text
        self.page_text = text
        self.save
      end
    end
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
    lead.assigned_to =    self.crm_id
    lead.phone = self.number
    lead.last_name = self.domain
    lead.first_name = self.number
    lead.background_info = self.tags.to_s
    lead.save
    end
  end


  def tags
    self.keywords.to_s.delete("[").delete("]").delete('"')
  end

  def area_code
    if self.number[0].to_s == "1"
      area = self.number.to_s[1..3]
    else
      area = self.number.to_s[0..2]
    end
    area
  end


  def geotag
    identifier = Phonelib.parse (self.number)

    begin
      state = Integer(self.area_code).to_region
      self.location = state if state
    rescue
      # Ignore
    end

    if identifier
      self.number_type = identifier.human_type
      self.country = identifier.country
      self.location ||= identifier.geo_name
    else
      self.destroy
    end

  end

  def self.to_csv(options = {})
    csv_string = CSV.generate(options) do |csv|
      csv << ["Phone", "Tags", "Source", "Date"]
      all.each do |record|
        csv << [record.number, record.keywords, record.domain, record.created_at.to_date]
      end
    end
    csv_string
  end
  


  def score
    missing = self.attributes.values.select(&:nil?).count
    total = self.attributes.count
    (((total.to_f - missing.to_f) / total.to_f) * 100).round(1)
  end

  def better_number
    self.number.phony_formatted(:normalize => :US, :spaces => '-')
  end


end
