class Subscription < ActiveRecord::Base
  include Koudoku::Subscription

  attr_accessible :credit_card_token, :plan_id, :stripe_id, :owner_id, :user_id, :card_type, :last_four

  belongs_to :user
  belongs_to :coupon
  #after_save :manage_user_credits

  def manage_user_credits
    @user = self.user
    if @user
    if self.plan_id == 1
     @user.role = "basic"
     @user.save
    elsif self.plan_id == 2
     @user.role = "advantage"
     @user.save
    elsif self.plan_id == 3
      @user.role = "enterprise"
      @user.save
    end
    end

  end

end
