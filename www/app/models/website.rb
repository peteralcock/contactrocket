class Website < ActiveRecord::Base
  require 'csv'
  validates_uniqueness_of :domain, scope: :user_id
  belongs_to :user
  attr_accessible  :author, :company_id, :user_id, :person_id, :is_active,
                   :domain, :url, :title, :meta, :domain_suffix, :whois,
                   :meta_keywords, :google_links, :meta_description, :website_id
  has_many :email_leads, :foreign_key => :domain, :primary_key => :domain
  has_many :phone_leads, :foreign_key => :domain, :primary_key => :domain
  has_many :social_leads, :foreign_key => :domain, :primary_key => :domain
  has_many :companies, :foreign_key => :domain, :primary_key => :domain
  scope :by_user, lambda {|user| where(:user_id => user) }
  scope :by_domain, lambda {|domain| where(:domain => domain) }
  scope :is_active, lambda {  where(:is_active => true) }
  scope :is_inactive, lambda {  where(:is_active => false) }
  after_create :whois_me
  searchkick callbacks: :async,  word_start: [:domain], suggest: [:domain] # , wordnet: true


  def self.import(file, user_id)
    counter = 0
    CSV.foreach(file.path, headers: false) do |row|

      if counter > 1000
        return true
      end

      url = row[0]

      if url and (url.match(/https?:\/\/.*$/i) or url.match(/http?:\/\/.*$/i) or url.match("http"))
        job_id = SecureRandom.hex(12)
        SpiderWorker.perform_async(url, user_id, job_id)
        counter += 1
      elsif url and url.match(".") and !(url.match(/https?:\/\/.*$/i) or url.match(/http?:\/\/.*$/i) or url.match("http"))
        url = ["http://", url].join
        job_id = SecureRandom.hex(12)
        SpiderWorker.perform_async(url, user_id, job_id)
        counter += 1
      end
    end
  end

  def whois_me
      WhoisWorker.perform_async(self.domain)
  end
end


