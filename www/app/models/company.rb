require 'uri'
class Company < ActiveRecord::Base

  self.table_name = "companies"
  has_many :email_leads, :foreign_key => :domain, :primary_key => :domain
  has_many :phone_leads, :foreign_key => :domain, :primary_key => :domain
  has_many :social_leads, :foreign_key => :domain, :primary_key => :domain
  has_many :people, :foreign_key => :domain, :primary_key => :domain
  scope :with_image, lambda { where.not(:image_url => nil) }
  scope :by_state, lambda {|state| where(:state => state) }
  scope :by_country, lambda {|state| where(:state => state) }
  scope :by_domain, lambda {|domain| where(:domain => domain) }
  scope :by_website, lambda {|website| where(:website => website) }
  scope :by_employees, lambda {|employees| where(:employees_exact > employees) }
  scope :by_revenue, lambda {|revenue| where(:revenue_exact > revenue) }
  scope :by_industry, lambda {|industry| where(:industry => industry) }
  scope :updated_recently, lambda {where(:updated_at => [24.hours.ago..Time.now]) }
  scope :not_updated_recently, lambda {where(:updated_at => [1.year.ago..1.month.ago]) }
  alias_attribute :display_name, :company_name

  has_many :searches, class_name: "Searchjoy::Search", as: :convertable

  searchkick callbacks: :async, suggest: [:industry], locations: ["location"],
             conversions: ["unique_user_conversions", "total_conversions"],
             index_name: "companies", similarity: "BM25", batch_size: 500

  def self.scrape
     select(:id, :website).find_each do |biz|
      job_id = SecureRandom.hex(12)
      SpiderWorker.perform_async(biz.website, 1, job_id)
      CompanyAnalysisWorker.perform_async(biz.id)
      puts biz.id
    end
  end


  def self.scrub_empty
    Company.where(:image_url => nil).find_each do |biz|
      CompanyAnalysisWorker.perform_async(biz.id)
    end
  end

  def  crawl
    url = self.website
    user = User.first
      job_id = SecureRandom.hex(12)
      SpiderWorker.perform_async(url, user.id, job_id)
      puts url
  end

  def self.crawl
    urls = Company.pluck(:website).uniq
    user = User.find_by(:email => "testpoop@example.com")
    urls.each do |url|
      job_id = SecureRandom.hex(12)
      SpiderWorker.perform_async(url, user.id, job_id)
      puts url
    end
  end

  def keywords
   self.description.to_s.split(" ").uniq
  end

  def self.to_csv(options = {})
    csv_string = CSV.generate(options) do |csv|
      csv << ["Company", "Industry", "Name", "Job Title", "City", "State", "Country", "Description"]
      all.each do |record|
         csv <<  [record.company_name, record.industry,  record.contact_person, record.contact_person_title, record.city, record.state, record.country, record.description]
      end
    end
    csv_string
  end

 def search_data
   attributes.merge location: {lat: latitude, lon: longitude}
   attributes.merge unique_user_conversions: searches.group(:query).uniq.count(:user_id)
   attributes.merge total_conversions: searches.group(:query).count

   as_json only: [:company_name, :address, :city, :state, :zip_code, :phone_number, :contact_person_email,
                  :contact_person_phone, :country, :website, :domain, :contact_person, :contact_person_title,
                  :important_people, :industry, :subcategory, :sic_code_description, :latitude, :longitude,
                  :location, :unique_user_conversions, :total_conversions, :sic_code]
 end


  def tags
    self.description.split(" ").uniq
  end

  def score
    missing = self.attributes.values.select(&:nil?).count
    total = self.attributes.count
    (((total.to_f - missing.to_f) / total.to_f) * 100).round(1)
  end



end

