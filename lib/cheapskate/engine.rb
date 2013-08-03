module Cheapskate
  class Engine < Rails::Engine
    isolate_namespace Cheapskate

    initializer :append_migrations do |app|
      config.paths["db/migrate"].expanded.each do |expanded_path|
        app.config.paths["db/migrate"] << expanded_path
      end
    end

    rake_tasks do
      load 'cheapskate/tasks/cheapskate.rake'
    end
  end
end
