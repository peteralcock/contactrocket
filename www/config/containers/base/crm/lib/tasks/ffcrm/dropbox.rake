# Copyright (c) 2011-2016 Velo Inc.
#
#
#
#------------------------------------------------------------------------------
namespace :crcrm do
  namespace :dropbox do
    desc "Run dropbox crawler and process incoming emails"
    task run: :environment do
      require "contact_rocket_crm/mail_processor/dropbox"
      ContactRocketCRM::MailProcessor::Dropbox.new.run(dry_run = false)
    end

    namespace :run do
      desc "[Dry run] - Run dropbox crawler and process incoming emails"
      task dry: :environment do
        require "contact_rocket_crm/mail_processor/dropbox"
        ContactRocketCRM::MailProcessor::Dropbox.new.run(dry_run = true)
      end
    end

    desc "Set up email dropbox based on currently loaded settings"
    task setup: :environment do
      require "contact_rocket_crm/mail_processor/dropbox"
      ContactRocketCRM::MailProcessor::Dropbox.new.setup
    end
  end
end
