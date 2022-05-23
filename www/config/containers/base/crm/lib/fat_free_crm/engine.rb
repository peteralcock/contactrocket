# Copyright (c) 2011-2016 Velo Inc.
#
#
#
#------------------------------------------------------------------------------
module ContactRocketCRM
  class Engine < ::Rails::Engine
    config.autoload_paths += Dir[root.join("app/models/**")] +
                             Dir[root.join("app/controllers/entities")]

    config.active_record.observers = [:lead_observer, :opportunity_observer,
                                      :task_observer, :entity_observer]

    initializer "model_core.factories", :after => "factory_girl.set_factory_paths" do
      FactoryGirl.definition_file_paths << File.expand_path('../../../spec/factories', __FILE__) if defined?(FactoryGirl)
    end

    initializer :append_migrations do |app|
      unless app.root.to_s == root.to_s
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end

  end
end
