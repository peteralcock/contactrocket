class Plan < ActiveRecord::Base
  has_many :subscriptions
  include Koudoku::Plan
  attr_accessible :display_order,:max_searches, :max_targets,
                  :max_contacts, :max_pages, :max_bandwidth,
                  :max_validations, :description, :features,
                  :highlight, :interval, :name, :price, :stripe_id
end
