class DarkWorker
  include Sidekiq::Worker
  sidekiq_options   :retry => true, :backtrace => true

  def perform(email_address)

      unless email_address.match("gmail.com") or email_address.match("yahoo.com") or email_address.match("hotmail.com") or email_address.match("msn.com") or email_address.match("aol.com")
          checker = ["ubuntu", $public_hostname].join("@")
          validator = EmailAuthentication::Base.new
          result = validator.check(email_address, checker)
          if result
            email = EmailLead.find_or_initialize_by(:address => email_address, :user_id => 1)
            email.smtp_reply = result[1].to_s.first(255)
            email.is_valid = true
            email.save
          end
      end
    end
  end



