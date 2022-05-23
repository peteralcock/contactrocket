class Person < ActiveRecord::Base
  include Gravtastic

  attr_accessible  :name, :domain, :first_name, :last_name, :middle_name, :title, :company_id
  belongs_to :company
  alias_attribute :display_name, :name
  searchkick callbacks: :async,  word_start: [:name], suggest: [:name] #, wordnet: true
  gravtastic :secure => true,
             :filetype => :gif,
             :size => 100


  def add_to_crm(user_id)
    x = CrmLead.new
    x.rating = 0
    x.do_not_call = false
    x.created_at = Time.now
    x.updated_at = Time.now
    x.assigned_to = user_id
    x.email = self.email_address
    x.phone = self.phone_number
    x.access = "Private"
    x.user_id = user_id
    x.first_name = self.first_name
    x.last_name = self.last_name
    x.save
  end


  def icon
    "user"
  end


end
