class Website < ActiveRecord::Base
  validates_uniqueness_of :domain, scope: :user_id
  belongs_to :user

  has_many :email_leads #, :foreign_key => :domain, :primary_key => :domain
  has_many :phone_leads #, :foreign_key => :domain, :primary_key => :domain
  has_many :social_leads #, :foreign_key => :domain, :primary_key => :domain
  has_many :companies, :foreign_key => :domain, :primary_key => :domain
  scope :by_user, lambda {|user| where(:user_id => user) }
  scope :by_domain, lambda {|domain| where(:domain => domain) }
  scope :is_active, lambda {  where(:is_active => true) }
  scope :is_inactive, lambda {  where(:is_active => false) }
  searchkick callbacks: :async
 # after_create :whois_me

  def locate_me
    ip = IPSocket::getaddress(self.domain)
    result = Curl.get("http://#{ENV['API_HOST']}:8882/locate?ip=#{ip}")
    if result
      self.update(:location => result.body_str)
    end
  end


  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      website = find_by_id(row["id"]) || new
      website.attributes = row.to_hash.slice(*accessible_attributes)
      website.save!
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
      when ".csv" then Csv.new(file.path, nil, :ignore)
      when ".xls" then Excel.new(file.path, nil, :ignore)
      when ".xlsx" then Excelx.new(file.path, nil, :ignore)
      else raise "Unknown file type: #{file.original_filename}"
    end
  end



  def whois_me
      WhoisWorker.perform_async(self.domain)
  end
end


