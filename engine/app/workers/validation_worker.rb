class ValidationWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker # Important!
  include Sidekiq::Benchmark::Worker
  sidekiq_options   :queue => 'validation', :retry => false, :backtrace => true, expires_in: 1.hour

  def perform(email_address, user_id)
    benchmark.extraction_metric do

      email = EmailLead.find_or_initialize_by(:address => email_address, :user_id => user_id)

    if email
      email_domain = email.address.rpartition("@")[2]
      school = Swot::school_name email.address

      if school or email_domain.downcase.match(".edu")
        email.organization = school || "Education"
      end

      # govt_domain = Gman.new email.address
      #
      # if govt_domain or email_domain.downcase.match(".gov")
      #   email.organization = govt_domain.agency
      #   email.organization ||= "Government"
      # end

    unless email.blank? or email.is_valid or email.address.match("gmail.com") or email.address.match("abuse") or email.address.match("yahoo.com") or email.address.match("hotmail.com") or email.address.match("msn.com") or email.address.match("aol.com") or email.address.split(".").last.match("ca")
      checker = ["support", $public_hostname].join("@")
      validator = EmailAuthentication::Base.new
      result = validator.check(email.address, checker)
        if result and result[0] and result.to_s.match("250")
          email.smtp_reply = result[1].to_s.first(255)
          email.is_valid = true
        else
          email.is_valid = false
        end
    end
    email.save
    end
      benchmark.finish
    end
  end

  def permutate(first_name, last_name, domain)

    first_initial = first_name[0]
    last_initial = last_name[0]

    # Define each name permutation manually
    name_permutations = <<PERMS
{first_name}
{last_name}
{first_initial}
{last_initial}
{first_name}{last_name}
{first_name}.{last_name}
{first_initial}{last_name}
{first_initial}.{last_name}
{first_name}{last_initial}
{first_name}.{last_initial}
{first_initial}{last_initial}
{first_initial}.{last_initial}
{last_name}{first_name}
{last_name}.{first_name}
{last_name}{first_initial}
{last_name}.{first_initial}
{last_initial}{first_name}
{last_initial}.{first_name}
{last_initial}{first_initial}
{last_initial}.{first_initial}
{first_name}-{last_name}
{first_initial}-{last_name}
{first_name}-{last_initial}
{first_initial}-{last_initial}
{last_name}-{first_name}
{last_name}-{first_initial}
{last_initial}-{first_name}
{last_initial}-{first_initial}
{first_name}_{last_name}
{first_initial}_{last_name}
{first_name}_{last_initial}
{first_initial}_{last_initial}
{last_name}_{first_name}
{last_name}_{first_initial}
{last_initial}_{first_name}
{last_initial}_{first_initial}
PERMS

    # substitutions to get all permutations to an Array
    name_permutations = name_permutations.gsub('{first_name}', first_name)
                            .gsub('{last_name}', last_name)
                            .gsub('{first_initial}', first_initial)
                            .gsub('{last_initial}', last_initial)
                            .split($/)

    # accept domain arg to be a string or an array
    # %40 => @
    if domain.is_a? String
      domain = ['%40'].product domain.split
    elsif domain.is_a? Array
      domain = ['%40'].product domain
    else
      raise ArgumentError, 'Domain was neither a String or Array'
    end

    name_and_domains = name_permutations.product domain

    # combine names and domains
    # return permuations
    permutations = name_and_domains.map {|email| email.join }
  end



end


