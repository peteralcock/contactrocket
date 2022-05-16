require 'swot'
class EmailLead < ActiveRecord::Base
  validates_uniqueness_of :address, scope: :user_id
  validate :mail_checker
  belongs_to :website #, :foreign_key => :domain, :primary_key => :domain
  belongs_to :user
  after_create :validate_address
  searchkick callbacks: :async #,  word_start: [:address, :domain], suggest: [:address] #, wordnet: true

  # after_create :get_page_text
  def get_page_text
    ExtractWorker.perform_async("EmailLead", self.id) # unless Rails.env.development?
  end

  def validate_address
      ValidationWorker.perform_async(self.address, self.user_id)
  end

  def mail_checker
   MailChecker(self.address)
  end


  def score
    missing = self.attributes.values.select(&:nil?).count
    total = self.attributes.count
    (((total.to_f - missing.to_f) / total.to_f) * 100).round(1)
  end

  def names
    names = self.page_text.scan(/([A-Z][a-z]+(?=\s[A-Z])(?:\s[A-Z][a-z]+)+)/)
    return names
  end

  def is_academic?
    Swot::is_academic? self.address
  end

  def display_name
    self.address
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

  def self.bulk_crawl(ids=[])

    if ids.empty?
      urls = Company.select(:website, :id).pluck(:website).uniq
      else
      urls = Company.select(:website, :id).find(ids).pluck(:website).uniq
    end

    user = User.last
    puts ">> Loading #{urls.count} websites into crawler..."
    urls.each do |url|
      job_id = [user.id, "__", url].join
      SpiderWorker.perform_async(url, user.id, job_id)
    end
    puts "-- #{urls.count} targets acquired --"
  end

  def email_type
    if self.address[-3..-1] == "com"
      type =  "Company"
    elsif self.address[-3..-1] == "gov"
      type =   "Government"
    elsif self.address[-3..-1] == "org"
      type =  "Non-Profit"
    elsif self.address[-3..-1] == "edu"
      type =  "Education"
    elsif self.address[-3..-1] == "mil"
      type =   "Military"
    elsif self.address[-3..-1] == "net"
      type =  "Technology"
    else
      type =  ""
    end
    type ||= self.domain[-1..-4]
    return type
  end

end

