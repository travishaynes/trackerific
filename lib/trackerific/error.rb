module Trackerific
  # Raised if something other than tracking information is returned.
  class Error < StandardError
    attr_accessor :request, :response
  end
end
