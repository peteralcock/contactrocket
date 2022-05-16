require 'resolv'
class MxRecordValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    mail_servers = Resolv::DNS.open.getresources(value.split('@')[1], Resolv::DNS::Resource::IN::MX)
    if mail_servers.empty? then
      record.errors[attribute] << "Does not have a MX record assosiated with mail id"
    end
  end
end