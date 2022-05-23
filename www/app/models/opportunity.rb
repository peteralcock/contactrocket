class Opportunity < ActiveRecord::Base
  belongs_to :user
  self.table_name = "opportunities"
  attr_accessible :stage
  
end
