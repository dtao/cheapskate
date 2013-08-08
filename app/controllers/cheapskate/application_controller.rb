module Cheapskate
  class ApplicationController < ActionController::Base
    include Cheapskate::Adapter
    include Cheapskate
  end
end
