class UserMailer < ActionMailer::Base
  default :from => "hello@your-server.net"

  def expire_email(user)
    mail(:to => user.email, :subject => "Subscription Cancelled")
  end

  def marketing(email)
    @email = email
    mail(:to => @email, :subject => "Someone discovered you with ContactRocket!")
  end

  def welcome_email(user)
    @user = user
    #track user: user
    #track extra: {campaign_id: 1}
    #track url_options: {host: "your-server.net"}
    mail(:to => @user.email, :subject => "Welcome aboard, Captain!")
  end
end
