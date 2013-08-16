module Cheapskate
  module ApplicationHelper
    def url_options_for_protocol(protocol)
      prefix = protocol.to_s.upcase

      {
        :protocol => Cheapskate::CONFIG["#{prefix}_PROTOCOL"],
        :host     => Cheapskate::CONFIG["#{prefix}_HOST"],
        :port     => Cheapskate::CONFIG["#{prefix}_PORT"]
      }
    end
  end
end
