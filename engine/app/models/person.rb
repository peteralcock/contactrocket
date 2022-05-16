class Person < ActiveRecord::Base
  belongs_to :company
  alias_attribute :display_name, :name
  searchkick callbacks: :async

end
