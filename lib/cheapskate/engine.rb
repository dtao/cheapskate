module Cheapskate
  class Engine < Rails::Engine
    initializer 'cheapskate.initialize' do
    end

    rake_tasks do
      load 'cheapskate/tasks/cheapskate.rake'
    end
  end
end
