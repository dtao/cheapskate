require "cheapskate/client"
require "cheapskate/engine"

module Cheapskate
  CONFIG = {
    'HTTP_PROTOCOL'  => 'http',
    'HTTP_HOST'      => Rails.env.development? && 'localhost' || nil,
    'HTTP_PORT'      => Rails.env.development? && 3000 || nil,

    'HTTPS_PROTOCOL' => Rails.env.development? && 'http' || 'https',
    'HTTPS_HOST'     => Rails.env.development? && 'localhost' || nil,
    'HTTPS_PORT'     => Rails.env.development? && 8000 || nil,

    'CLIENT_CLASS'   => Cheapskate::Client,
    'ROOT_PATH'      => '/'
  }
end
