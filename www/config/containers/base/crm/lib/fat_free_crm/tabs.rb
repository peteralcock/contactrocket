# Copyright (c) 2011-2016 Velo Inc.
#
#
#
#------------------------------------------------------------------------------
module ContactRocketCRM
  class Tabs
    cattr_accessor :main
    cattr_accessor :admin

    # Class methods.
    #----------------------------------------------------------------------------
    class << self
      def main
        @@main ||= (Setting[:tabs] && Setting[:tabs].dup)
      end

      def admin
        @@admin ||= (Setting[:admin_tabs] && Setting[:admin_tabs].dup)
      end
    end
  end
end
