# Copyright (c) 2011-2016 Velo Inc.
#
#
#
#------------------------------------------------------------------------------
#
# Removes simple_form's css class logic.
module SimpleForm
  module ActionViewExtensions
    module FormHelper
      def simple_form_for(record, options = {}, &block)
        options[:builder] ||= SimpleForm::FormBuilder
        options[:html] ||= {}
        unless options[:html].key?(:novalidate)
          options[:html][:novalidate] = !SimpleForm.browser_validations
        end

        with_simple_form_field_error_proc do
          form_for(record, options, &block)
        end
      end
    end
  end
end
