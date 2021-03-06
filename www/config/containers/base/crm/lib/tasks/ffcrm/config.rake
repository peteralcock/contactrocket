# Copyright (c) 2011-2016 Velo Inc.
#
#
#
#------------------------------------------------------------------------------
namespace :crcrm do
  namespace :config do
    desc "Setup database.yml"
    task :copy_database_yml do
      require 'fileutils'
      filename = "config/database.#{ENV['DB'] || 'postgres'}.yml"
      orig, dest = ContactRocketCRM.root.join(filename), Rails.root.join('config/database.yml')
      unless File.exist?(dest)
        puts "Copying #{filename} to config/database.yml ..."
        FileUtils.cp orig, dest
      end
    end

    #
    # Syck is not maintained anymore and Rails now prefers Psych by default.
    # Soon, contact_rocket_crm should also make the move, which involves adjustments to yml files.
    # However, each crcrm installation will have it's own syck style settings.yml files so we need to
    # provide help to migrate before switching it off. This task helps that process.
    #
    desc "Ensures all yaml files in the config folder are readable by Psych. If not, assumes file is in the Syck format and converts it for you [creates a new file]."
    task :syck_to_psych do
      require 'fileutils'
      require 'syck'
      require 'psych'
      Dir[File.join(Rails.root, 'config', '**', '*.yml')].each do |file|
        YAML::ENGINE.yamler = 'syck'
        puts "Converting #{file}"
        yml = YAML.load(File.read(file))
        FileUtils.cp file, "#{file}.bak"
        YAML::ENGINE.yamler = 'psych'
        File.open(file, 'w') { |file| file.write(YAML.dump(yml)) }
      end
    end
  end
end
