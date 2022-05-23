# Copyright (c) 2011-2016 Velo Inc.
#
#
#
#------------------------------------------------------------------------------

#
# Register and call when Setting class is loaded
# Load settings.default.yml
# Then override with settings.yml
# Don't override default settings in test environment
ActiveSupport.on_load(:contact_rocket_crm_setting) do
  setting_files = [ContactRocketCRM.root.join("config", "settings.default.yml")]
  setting_files << Rails.root.join("config", "settings.yml") unless Rails.env == 'test'
  setting_files.each do |settings_file|
    Setting.load_settings_from_yaml(settings_file) if File.exist?(settings_file)
  end
end
