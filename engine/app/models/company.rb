require 'uri'
require 'json'
require 'rubydns'
require 'rubydns/system'
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
  urls = Company.where(:note => "VALID").pluck(:website).uniq
  urls.each do |url|
    SpiderWorker.perform_async(url, 1, url)
  end
  puts "DONE"
end

  def self.scrub
    user = User.first

    find_each do |biz|
      CompanyAnalysisWorker.perform_async(biz.id)
      job_id = SecureRandom.hex(8)
      SpiderWorker.perform_async(biz.website, user.id, job_id)
    end
  end


  def keywords
   self.description.to_s.split(" ").uniq
  end

  def self.to_csv(options = {})
    csv_string = CSV.generate(options) do |csv|
      csv << ["Company", "Industry", "Contact Name", "Contact Title", "City", "State", "Country", "Description"]
      all.each do |record|
         csv <<  [record.company_name, record.industry,  record.contact_person, record.contact_person_title, record.city, record.state, record.country, record.description]
      end
    end
    csv_string
  end


 def search_data
   as_json only: [:company_name, :address, :city, :state, :country, :website, :domain,
    :contact_person, :contact_person_title, :important_people, :industry, :description]
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

