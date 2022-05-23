# Copyright (c) 2011-2016 Velo Inc.
#
#
#
#------------------------------------------------------------------------------

namespace :crcrm do
  desc "Generate a secret token for Rails to use."
  task :secret do
    require 'securerandom'
    secret = SecureRandom.hex(64)
    filename = File.join(Rails.root, 'config', 'initializers', 'secret_token.rb')
    File.open(filename, 'w') { |f| f.puts "ContactRocketCRM::Application.config.secret_token = '#{secret}'" }
  end
end
