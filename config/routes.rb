Cheapskate::Engine.routes.draw do
  post 'register'   => 'application#register'
  get  'registered' => 'application#complete_registration'
  post 'login'      => 'application#login'
  get  'logged_in'  => 'application#complete_login'
end
