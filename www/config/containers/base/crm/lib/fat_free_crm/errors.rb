# Copyright (c) 2011-2016 Velo Inc.
#
#
#
#------------------------------------------------------------------------------
module ContactRocketCRM
  module ActiveModel
    module Errors
      # Override ActiveModel::Errors#each so we could display validation
      # errors as is without rendering the attribute name. Simply place
      # a caret as the first character of the error message.
      #
      # This feature was handled by 'advanced_errors' plugin in Rails 2.x
      # version of ContactRocket CRM.
      #----------------------------------------------------------------------------
      def self.included(base)
        base.class_eval do
          alias_method :each, :each_with_explicit_error
        end
      end

      def each_with_explicit_error
        keys.each do |attribute|
          self[attribute].each do |error|
            if error.start_with?('^')
              yield :portal, error[1..-1]   # Drop the attribute.
            else
              yield attribute, error      # This is default Rails3 behavior.
            end
          end
        end
      end
    end
  end
end

ActiveModel::Errors.send(:include, ContactRocketCRM::ActiveModel::Errors)
