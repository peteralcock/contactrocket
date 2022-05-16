class NamemailWorker
  include Sidekiq::Worker
  sidekiq_options   :queue => 'validation', :retry => false, :backtrace => true #, expires_in: 1.day

  def perform(first, last, domain)
    checker = ["hello", $public_hostname].join("@")
    validator = EmailAuthentication::Base.new
    combos = self.permutate(first,last,domain)
    combos.each do |possible_email|
      result = validator.check(possible_email, checker)
      if result and result[0]
        email = EmailLead.new(:address => possible_email, :user_id => 1, :domain => domain)
        email.smtp_reply = result[1].to_s.first(255)
        email.is_valid = true
        email.save
        puts "#{email.address} is valid!"
      end
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
      domain = ['@'].product domain.split
    elsif domain.is_a? Array
      domain = ['@'].product domain
    else
      raise ArgumentError, 'Domain was neither a String or Array'
    end

    name_and_domains = name_permutations.product domain

    # combine names and domains
    # return permuations
    permutations = name_and_domains.map {|email| email.join }
    permutations
  end

end
