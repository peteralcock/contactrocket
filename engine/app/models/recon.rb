require 'json'
require 'uri'
class Recon

  def facts(entity)

  end

  def email(address)

  end

  def phone(number)

  end

  def profile(url)

  end

  def product(url)

  end

  def website(url)

  end

  def article(url)

  end

  def whois(domain)

  end


  def contacts(domain)
    hash = {}
    website = Website.where(:domain => domain).first
    if website
      emails = website.email_leads
      phones = website.phone_leads
      socials = website.social_leads
      hash[:emails] = emails
      hash[:social] = socials
      hash[:phones] = phones
    end
    hash
  end


  def youtube(url)

  end

  def ograph_data(url)

  end

  def facebook(url)

  end

  def twitter(url)

  end

  def linkedin(url)

  end

  def instagram(url)

  end

  def pinterest(url)

  end

  def influence(username, network)

  end


end