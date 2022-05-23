class User < ActiveRecord::Base
  include Redis::Objects
  devise :invitable,  :encryptable, :registerable,:database_authenticatable,  :confirmable, # :async,
  :uid, :recoverable, :validatable, :omniauthable, :doorkeeper, :trackable, :rememberable
  attr_accessible :admin, :email, :name, :password, :password_confirmation,:password_digest, :password_salt, :provider, :uid,
                  :username, :remember_me, :authentication_token, :plan_id, :role
  has_many :messages, class_name: "Ahoy::Message"
  counter :api_credits, :start => 10000
  counter :crawl_credits, :start => 150
  counter :contact_credits, :start => 500
  counter :mileage, :start => 0
  counter :active_engines, :start => 0, :expiration => 15.minutes
  counter :bandwidth_used
  counter :target_count
  counter :search_count
  counter :email_count
  counter :phone_count
  counter :social_count
  set :job_ids
  set :batch_ids
  set :quicklist
  set :pages_crawled
  set :notifications

  has_one :subscription
  has_many :bots
  has_many :websites
  has_many :accounts
  has_many :leads
  has_many :opportunities
  has_many :contacts
  has_many :tasks
  has_many :campaigns
  has_many :phone_leads
  has_many :social_leads
  has_many :email_leads

  enum role: [:user, :admin, :trial, :basic, :advantage, :enterprise]

  after_initialize :set_default_role, :if => :new_record?
  before_validation :setup_account, :if => :new_record?

    before_create do
      self.username = self.uid
      result =  Apartment::Tenant.create(self.uid)
    end

    # after_create do
        # UserMailer.welcome_email(self).deliver
    # end

  def my_jobs
    jobs = self.websites.last(3)
    job_times = []
    jobs.each do |job|
      job_times << [job.domain, ((job.created_at + 15.minutes) - Time.now).to_i.abs]
    end
    job_times

  end

  def password_match?
    self.errors[:password] << "can't be blank" if password.blank?
    self.errors[:password_confirmation] << "can't be blank" if password_confirmation.blank?
    self.errors[:password_confirmation] << "does not match password" if password != password_confirmation
    password == password_confirmation && !password.blank?
  end

  # new function to set the password without knowing the current
  # password used in our confirmation controller.
  def attempt_set_password(params)
    p = {}
    p[:password] = params[:password]
    p[:password_confirmation] = params[:password_confirmation]
    update_attributes(p)
  end

  # new function to return whether a password has been set
  def has_no_password?
    self.encrypted_password.blank?
  end

  def update_without_password(params={})
    params.delete(:current_password)
    super(params)
  end



  # Devise::Models:unless_confirmed` method doesn't exist in Devise 2.0.0 anymore.
  # Instead you should use `pending_any_confirmation`.
  def only_if_unconfirmed
    pending_any_confirmation {yield}
  end


  def all_tags

    emails = self.email_leads
    phones = self.phone_leads
    socials = self.social_leads

    social_tags = socials.map(&:keywords)
    email_tags = emails.map(&:keywords)
    phone_tags = phones.map(&:keywords)
    tags = [phone_tags, email_tags, social_tags].flatten.uniq.to_s
    tags = tags.delete("[").delete("]").delete('"').gsub(",", " ").to_s
  end

  def job_status(bid)
    batch = Sidekiq::Batch::Status.new(bid) # bid is the batch ID
    batch
  end

  def recent_jobs
    recent_urls = self.websites.last(5).map(&:url)
    info = {}
    recent_urls.each do |job_id|
    data = Sidekiq::Status::get_all job_id
    info[job_id] = data
    end

    info

  end


  def available_engines
    self.max_engines - self.active_engines.value
  end

  def active_missions
    Website.where(:user_id => self.id, :created_at => 5.minutes.ago..Time.now).count
  end

  def job_progress(jid)
    container = SidekiqStatus::Container.load(jid)
    if container
      [container.status, container.pct_complete]
    end
  end

  def crm_id
   self.crm_user.id
  end

  def total_contacts
   (self.email_leads.count + self.phone_leads.count + self.social_leads.count)
  end

  def current_plan
    if self.subscription and self.subscription.plan_id
      self.subscription.plan_id
    else
      0
    end
  end

  def max_targets
    plan = self.current_plan
    case plan
      when 0
        20
      when 1
        5000
      when 2
        20000
      when 3
        100000
      when 4
        9999999999
      else
        20
    end
  end

  def current_progress
    if self.websites.count > 0
      job_id = self.websites.last.url
      progress = Sidekiq::Status::pct_complete job_id
      progress
      end
  end


  def max_engines
    plan = self.current_plan
    case plan
      when 0
        4
      when 1
        8
      when 2
        12
      when 3
        24
      else
        4
    end
  end

  def max_searches
    plan = self.current_plan
    case plan
      when 0
        5
      when 1
        250
      when 2
        1000
      when 3
        5000
      when 4
        9999999999
      else
        5
    end
  end


  def max_pages
    plan = self.current_plan
    case plan
      when 0
        1000
      when 1
        20000
      when 2
        100000
      when 3
        1000000
      when 4
        10000000
      else
        1000
    end
  end

  def max_validations
    plan = self.current_plan
    case plan
      when 0
        10
      when 1
        200
      when 2
        1000
      when 3
        10000
      when 4
        9999999999
      else
        10
    end
  end

  def max_bandwidth
    plan = self.current_plan
    case plan
      when 0
        10000000
      when 1
        100000000
      when 2
        1000000000
      when 3
        10000000000
      when 4
        100000000000
      else
        10000000
    end
  end


  def max_contacts
    plan = self.current_plan
    case plan
      when 0
        150
      when 1
        500
      when 2
        5000
      when 3
        10000
      when 4
        9999999999
      else
        150
    end
  end

  def contacts
    [self.email_leads, self.phone_leads, self.social_leads].flatten
  end

  def setup_account
      @token = SecureRandom.hex(4)
      self.password = @token
      self.password_confirmation = @token
      self.authentication_token = @token
  end


  def set_default_role
    self.role ||= "trial"
  end



  def new_record?
    self.id.nil?
  end

end
