# Copyright (c) 2011-2016 Velo Inc.
#
#
#
#------------------------------------------------------------------------------

module ContactRocketCRM
  class << self
    # Return either Application or Engine,
    # depending on how ContactRocket CRM has been loaded
    def application
      engine? ? Engine : Application
    end

    delegate :root, to: :application

    # Are we running as an engine?
    def engine?
      defined?(ContactRocketCRM::Engine).present?
    end

    def application?
      !engine?
    end
  end
end

# Load ContactRocket CRM as a Rails Engine, unless running as a Rails Application
unless defined?(ContactRocketCRM::Application)
  require 'contact_rocket_crm/engine'
end

require 'contact_rocket_crm/load_settings' # register load hook for Setting

# Require gem dependencies, monkey patches, and vendored plugins (in lib)
require "contact_rocket_crm/gem_dependencies"
require "contact_rocket_crm/gem_ext"

require "contact_rocket_crm/custom_fields" # load hooks for Field
require "contact_rocket_crm/version"
require "contact_rocket_crm/core_ext"
require "contact_rocket_crm/comment_extensions"
require "contact_rocket_crm/exceptions"
require "contact_rocket_crm/export_csv"
require "contact_rocket_crm/errors"
require "contact_rocket_crm/i18n"
require "contact_rocket_crm/permissions"
require "contact_rocket_crm/exportable"
require "contact_rocket_crm/renderers"
require "contact_rocket_crm/fields"
require "contact_rocket_crm/sortable"
require "contact_rocket_crm/tabs"
require "contact_rocket_crm/callback"
require "contact_rocket_crm/view_factory"

require "country_select"
require "gravatar_image_tag"
