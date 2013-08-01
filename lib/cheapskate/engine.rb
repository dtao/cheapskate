module Cheapskate
  class Engine < Rails::Engine
    routes.draw do
      post '/register' => 'cheapskate#register'
      post '/login' => 'cheapskate#login'
      post '/complete_login' => 'cheapskate#complete_login'
    end
  end
end
