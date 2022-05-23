# Copyright (c) 2011-2016 Velo Inc.
#
#
#
#------------------------------------------------------------------------------
unless Rails.env.test?
  class ActionController::Base
    # Remove helpers residing in subdirectories from the list of application
    # helpers.  Basically we don't want helpers in app/helpers/admin/* to
    # override the ones in app/helpers/*.
    #----------------------------------------------------------------------------
    def self.all_application_helpers
      super.delete_if { |helper| helper.include?(File::SEPARATOR) }
    end
  end
end
