module Cheapskate
  module ApplicationHelper
    def url_options_for_protocol(protocol)
      if protocol == :https
        {
          :protocol => Cheapskate::HTTPS_PROTOCOL,
          :host     => Cheapskate::HTTPS_HOST,
          :port     => Cheapskate::HTTPS_PORT
        }
      else
        {
          :protocol => Cheapskate::HTTP_PROTOCOL,
          :host     => Cheapskate::HTTP_HOST,
          :port     => Cheapskate::HTTP_PORT
        }
      end
    end
  end
end
