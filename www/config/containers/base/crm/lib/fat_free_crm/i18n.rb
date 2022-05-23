# Copyright (c) 2011-2016 Velo Inc.
#
#
#
#------------------------------------------------------------------------------
require 'pathname'

module ContactRocketCRM
  module I18n
    #----------------------------------------------------------------------------
    def t(*args)
      if args.size == 1
        super(args.first, default: args.first.to_s)
      elsif args.second.is_a?(Hash)
        super(*args)
      elsif args.second.is_a?(Fixnum)
        super(args.first, count: args.second)
      else
        super(args.first, value: args.second)
      end
    end

    # Scan config/locales directory for ContactRocket CRM localization files
    # (i.e. *_contact_rocket_crm.yml) and return locale part of the file name.
    # We can't use ::I18n.available_locales because rails provides it's own
    # translations too and we only want the locales that ContactRocket CRM supports.
    #----------------------------------------------------------------------------
    def locales
      @@locales ||= ::I18n.load_path.grep(/_contact_rocket_crm\.yml$/).map { |path| Pathname.new(path).basename.to_s.match(/(.*)_contact_rocket_crm\.yml/)[1] }.uniq
    end

    # Return a hash where the key is locale name, and the value is language name
    # as defined in the locale_contact_rocket_crm.yml file.
    #----------------------------------------------------------------------------
    def languages
      @@languages ||= Hash[locales.map { |locale| [locale, t(:language, locale: locale)] }]
    end
  end
end

ActionView::Base.send(:include, ContactRocketCRM::I18n)
ActionController::Base.send(:include, ContactRocketCRM::I18n)
