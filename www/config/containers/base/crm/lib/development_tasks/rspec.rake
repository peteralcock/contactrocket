# Copyright (c) 2011-2016 Velo Inc.
#
#
#
#------------------------------------------------------------------------------
if defined?(RSpec)
  require 'rspec/core/rake_task'

  namespace :spec do
    desc "Preparing test env"
    task :prepare do
      tmp_env = Rails.env
      Rails.env = "test"
      Rake::Task["crcrm:config:copy_database_yml"].invoke
      puts "Preparing test database..."
      Rake::Task["db:schema:load"].invoke
      Rails.env = tmp_env
    end
  end

  Rake::Task["spec"].prerequisites.clear
  Rake::Task["spec"].prerequisites.push("spec:prepare")

end
