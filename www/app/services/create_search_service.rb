class CreateSearchService
  def call
    PhoneLead.reindex
    SocialLead.reindex
    EmailLead.reindex
    Person.reindex
    Website.reindex
  #  Company.reindex
    puts '-- SEARCH READY! --'
  end


  def load_company_data
    ActiveRecord::Base.connection.execute(IO.read([Rails.root, "/vendor/data/biz.sql"].join))
  end




end



