# Copyright (c) 2011-2016 Velo Inc.
#
#
#
#------------------------------------------------------------------------------
# Override engine views so that plugin views have higher priority.
Rails::Engine.initializers.detect { |i| i.name == :add_view_paths }
  .instance_variable_set("@block", proc do
    views = paths["app/views"].to_a
    unless views.empty?
      ActiveSupport.on_load(:action_controller) { append_view_path(views) }
      ActiveSupport.on_load(:action_mailer) { append_view_path(views) }
    end
  end
)
