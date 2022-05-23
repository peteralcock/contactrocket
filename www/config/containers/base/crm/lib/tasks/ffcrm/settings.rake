# Copyright (c) 2011-2016 Velo Inc.
#
#
#
#------------------------------------------------------------------------------
namespace :crcrm do
  namespace :settings do
    desc "Clear settings from database (reset to default)"
    task clear: :environment do
      Setting.delete_all
    end

    desc "Show current settings in the database"
    task show: :environment do
      Setting.select('name').order('name').pluck('name').each do |name|
        puts "\n#{name}:\n  #{Setting.send(name).inspect}"
      end
    end
  end
end
