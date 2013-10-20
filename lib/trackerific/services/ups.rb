module Trackerific
  module Services
    class UPS < Base
      require 'trackerific/builders/ups'
      require 'trackerific/parsers/ups'

      include Concerns::XML

      register :ups

      configure do |config|
        config.endpoint = '/Track'
        config.parser = Parsers::UPS
        config.builder = Builders::UPS
        config.package_id_matchers = [ /^.Z/, /^[HK].{10}$/ ]
      end

      format :xml

      base_uri case Trackerific.env
      when 'production' then 'https://www.ups.com/ups.app/xml'
      else 'https://wwwcie.ups.com/ups.app/xml'
      end
    end
  end
end
