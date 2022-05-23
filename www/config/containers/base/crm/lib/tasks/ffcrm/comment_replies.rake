# Copyright (c) 2011-2016 Velo Inc.
#
#
#
#------------------------------------------------------------------------------
namespace :crcrm do
  namespace :comment_replies do
    desc "Run comment inbox crawler and process incoming emails"
    task run: :environment do
      require "contact_rocket_crm/mail_processor/comment_replies"
      ContactRocketCRM::MailProcessor::CommentReplies.new.run(dry_run = false)
    end
    namespace :run do
      desc "[Dry run] - Run comment inbox crawler and process incoming emails"
      task dry: :environment do
        require "contact_rocket_crm/mail_processor/comment_replies"
        ContactRocketCRM::MailProcessor::CommentReplies.new.run(dry_run = true)
      end
    end

    desc "Set up comment inbox based on currently loaded settings"
    task setup: :environment do
      require "contact_rocket_crm/mail_processor/comment_replies"
      ContactRocketCRM::MailProcessor::CommentReplies.new.setup
    end
  end
end
