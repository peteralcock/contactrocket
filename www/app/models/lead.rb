class Lead < ActiveRecord::Base
  belongs_to :user
  self.table_name = "leads"

end
