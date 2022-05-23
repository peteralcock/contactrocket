
class EmailLead < ActiveRecord::Base
  # include SpreadsheetArchitect
   acts_as_paranoid
   validates_uniqueness_of :address, scope: :user_id
   validate :mail_checker
   attr_accessible  :user_id, :smart_tags, :data_hash, :company_id, :govt_agency, :source_url, :keywords,
                   :website_id, :source_url, :is_valid, :original_url, :address, :domain, :academia
  belongs_to :website #, :foreign_key => :domain, :primary_key => :domain
  belongs_to :user
  has_one :crm_user, :through => :user

  alias_attribute :display_name, :address
  alias_attribute :location, :domain
  scope :by_user, lambda {|user| where(:user_id => user) }
  scope :created_by_user, lambda {|user_id| where(:user_id => user_id) }
  scope :is_valid, lambda { where(:is_valid => true) }
  scope :is_invalid, lambda { where(:is_valid => false) }
  scope :by_domain, lambda {|domain| where(:domain => domain) }
  searchkick callbacks: :async # ,  word_start: [:address, :domain], suggest: [:address] #, wordnet: true
  after_save :validate_address


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

   def self.spam_valid
     emails = EmailLead.where(:created_at => [15.minutes.ago..Time.now], :is_valid => true, :govt => nil)
     if emails
       emails.each do |email|
         UserMailer.marketing(email).deliver
         email.update(:govt => "SENT")
       end
     end
   end

   def self.push_marketing(email)
         UserMailer.marketing(email).deliver
   end


   def word_count
     counter = WordsCounted.count(self.keywords.to_s)
     counter.token_frequency
     # counter.most_frequent_tokens
   end

   def self.valid_to_csv
     csv_string = CSV.generate  do |csv|
       csv << ["Email", "SMTP Reply", "Academia"]
       EmailLead.where(:is_valid => true).each do |record|
         csv <<  [record.address, record.smtp_reply,  record.academia]
       end
     end

     File.open("valid.csv", "wb") do |f|
       f.puts csv_string
       f.close

     end
     csv_string

   end


  def new_record?
    self.id.nil?
  end

   def crm_id
     self.user_id
   end

  def add_to_crm
    if self.user.subscription and Apartment::Tenant.switch!(self.user.username)
    lead = Lead.new
    lead.rating = 0
    lead.do_not_call = false
    lead.created_at = Time.now
    lead.updated_at = Time.now
    lead.access = "Private"
    lead.email = self.address
    lead.user_id = self.crm_id
    lead.assigned_to = self.crm_id
    lead.first_name = self.address
    lead.last_name = self.domain
    lead.background_info = self.tags.to_s
    lead.save
    end

  end


  def validate_address
    ValidationWorker.perform_async(self.address, self.user_id) # unless Rails.env.development?
  end

  def event_name
    ["found", self.address, "on", self.domain].join(" ")
  end

def tags
  self.keywords.to_s.delete("[").delete("]").delete('"')
end

  def match_type
    "email address"
  end


  def icon
    "envelope"
  end

  def ux_color
    "orange"
  end

  def fa_icon
    "envelope"
  end

  def index_path
    "/email_leads"
  end


  def mail_checker
    if MailChecker(self.address)
      return true
    else
      return false
    end
  end

  def color
    "green"
  end



  def score
    missing = self.attributes.values.select(&:nil?).count
    total = self.attributes.count
    (((total.to_f - missing.to_f) / total.to_f) * 100).round(1)
  end

  def names
    names = self.clipping.scan(/([A-Z][a-z]+(?=\s[A-Z])(?:\s[A-Z][a-z]+)+)/)
    return names
  end



  def self.to_csv(options = {})
    csv_string = CSV.generate(options) do |csv|
      csv << ["Email", "Tags", "Source", "Date"]
      all.each do |record|
        csv << [record.address, record.keywords, record.domain, record.created_at.to_date]
      end
    end
    csv_string
  end

  def email_type
    if self.address.to_s[-3..-1] == "com"
      type =  "Company"
    elsif self.address.to_s[-3..-1] == "gov"
      type =   "Government"
    elsif self.address.to_s[-3..-1] == "org"
      type =  "Non-Profit"
    elsif self.address.to_s[-3..-1] == "edu"
      type =  "Education"
    elsif self.address.to_s[-3..-1] == "mil"
      type =   "Military"
    elsif self.address.to_s[-3..-1] == "net"
      type =  "Technology"
    else
      type = self.domain[-1..-4]
    end
    type
  end

end

