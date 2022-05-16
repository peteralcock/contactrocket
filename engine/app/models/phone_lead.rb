

class PhoneLead < ActiveRecord::Base
  validates_uniqueness_of :number, scope: :user_id
  belongs_to :user
  belongs_to :website #, :foreign_key => :domain, :primary_key => :domain
  alias_attribute :display_name, :better_number
  alias_attribute :location, :state
  alias_attribute :website, :original_url
  after_validation :geotag

  scope :from_state, lambda {|state| where(:state => state) }
  scope :from_country, lambda {|country| where(:country => country) }
  scope :by_user, lambda {|user| where(:user_id => user) }
  scope :by_domain, lambda {|domain| where(:domain => domain) }
  # after_create :get_page_text
  searchkick callbacks: :async

  def get_page_text
    ExtractWorker.perform_async("PhoneLead", self.id) # unless Rails.env.development?
  end

  def event_name
    ["matched from ", self.domain].join
  end

  def tags
    self.keywords.delete("[").delete("]").delete('"')
  end

  def icon
    "phone"
  end

  def ux_color
    "pink"
  end

  def fa_icon
    "phone"
  end

  def display_name
    self.better_number
  end

  def index_path
    "/phone_leads"
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


  def color
    "orange"
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
