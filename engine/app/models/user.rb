
class User < ActiveRecord::Base
  include Redis::Objects

  counter :api_credits, :start => 10000
  counter :crawl_credits, :start => 150
  counter :contact_credits, :start => 500
  counter :mileage, :start => 0, :expiration => 1.minute

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
  set :email_addresses
  set :phone_numbers
  set :social_media_profiles

  set :pages_crawled, :expiration => 1.minute
  set :notifications, :expiration => 60.minutes

  has_many :websites
  has_many :email_leads,:through => :websites
  has_many :phone_leads,:through => :websites
  has_many :social_leads,:through => :websites

  enum role: [:user, :admin, :trial, :basic, :advantage, :enterprise]




  def available_engines
    self.max_engines - self.active_engines.value
  end


  def add_to_prospects(record)
    self.quicklist << record
  end

  def prospects(record)
    self.quicklist.members
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
        50
      when 1
        500
      when 2
        2000
      when 3
        10000
      when 4
        9999999999
      else
        50
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
        16
      when 3
        32
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



##########
# BENCHMARK US!

  def facebook_leads
    self.social_leads.sort { |x| x.social_network == "facebook"}
  end

# VERSUS...

  def twitter_leads
    SocialLead.by_user(self.id).where(:social_network => "twitter")
  end

##########

  def pinterest_leads
    SocialLead.by_user(self.id).where(:social_network => "pinterest")
  end


  def linkedin_leads
    SocialLead.by_user(self.id).where(:social_network => "linkedin")
  end


  def google_leads
    SocialLead.by_user(self.id).where(:social_network => "google")
  end

  def github_leads
    SocialLead.by_user(self.id).where(:social_network => "github")
  end


  def instagram_leads
    SocialLead.by_user(self.id).where(:social_network => "instagram")
  end


  def new_record?
    self.id.nil?
  end



end
