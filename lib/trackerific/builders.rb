module Trackerific
  module Builders
    module Base
      require 'trackerific/builders/base/soap'
      require 'trackerific/builders/base/xml'
    end

    require 'trackerific/builders/fedex'
    require 'trackerific/builders/ups'
    require 'trackerific/builders/usps'
  end
end
