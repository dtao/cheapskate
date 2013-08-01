module Cheapskate
  class Engine < Rails::Engine
    routes.draw do
      post '/register' => 'cheapskate#register'
      post '/login' => 'cheapskate#login'
      post '/complete_login' => 'cheapskate#complete_login'
    end

    rake_tasks do
      load 'cheapskate/tasks/cheapskate.rake'
    end
  end
end
