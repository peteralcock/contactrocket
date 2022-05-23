# Copyright (c) 2011-2016 Velo Inc.
#
#
#
#------------------------------------------------------------------------------
require 'rails/all'
require 'rails-observers'
require 'responders'
require 'jquery-rails'
require 'jquery-migrate-rails'
require 'jquery-ui-rails'
require 'select2-rails'
require 'haml'
require 'sass'
require 'acts_as_commentable'
require 'acts_as_list'
require 'acts-as-taggable-on'
require 'responds_to_parent'
require 'dynamic_form'
require 'paperclip'
require 'simple_form'
require 'will_paginate'
require 'authlogic'
require 'ransack'
require 'ransack_ui'
require 'paper_trail'
require 'cancan'
require 'rails3-jquery-autocomplete'
require 'ffaker'
require 'premailer'
require 'nokogiri'
require 'font-awesome-rails'
require 'thor'
require 'rails_autolink'

# Load redcloth if available (for textile markup in emails)
begin
  require 'redcloth'
rescue LoadError
end