Cheapskate::Engine.routes.draw do
  post 'register' => 'application#register'
  post 'login' => 'application#login'
  get 'complete_login' => 'application#complete_login'
end
