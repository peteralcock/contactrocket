# Copyright (c) 2011-2016 Velo Inc.
#
#
#
#------------------------------------------------------------------------------
module ContactRocketCRM
  module Exportable
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def exportable(_options = {})
        unless included_modules.include?(InstanceMethods)
          include InstanceMethods
          extend SingletonMethods
        end
      end
    end

    module InstanceMethods
      def user_id_full_name
        user = self.user
        user ? user.full_name : ''
      end

      def self.included(base)
        if base.instance_methods.include?(:assignee) || base.instance_methods.include?('assignee')
          define_method :assigned_to_full_name do
            user = assignee
            user ? user.full_name : ''
          end
        end

        if base.instance_methods.include?(:completor) || base.instance_methods.include?('completor')
          define_method :completed_by_full_name do
            user = completor
            user ? user.full_name : ''
          end
        end
      end
    end

    module SingletonMethods
    end
  end # Exportable
end # ContactRocketCRM

ActiveRecord::Base.send(:include, ContactRocketCRM::Exportable)
