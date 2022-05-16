class UserMailer < ActionMailer::Base
  default :from => "no-reply@your-server.net"

  def marketing(email)
    mail(:to => email, :subject => "Someone's looking for you on ContactRocket!")
  end


end
