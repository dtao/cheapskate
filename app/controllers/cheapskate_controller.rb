BASE_CONTROLLER_CLASS = defined?(ApplicationController) ?
  ApplicationController :
  ActionController::Base

class CheapskateController < BASE_CONTROLLER_CLASS
  include Cheapskate::Adapter
  include Cheapskate
end
