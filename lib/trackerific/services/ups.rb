module Trackerific
  module Services
    class UPS < Base
      require 'trackerific/builders/ups'
      require 'trackerific/parsers/ups'

      include Concerns::XML, HTTParty

      register :ups

      self.xml_endpoint = '/Track'
      self.xml_parser = Parsers::UPS
      self.xml_builder = Builders::UPS

      format :xml

      base_uri case (ENV['RAILS_ENV'] || 'production')
      when 'production' then 'https://www.ups.com/ups.app/xml'
      else 'https://wwwcie.ups.com/ups.app/xml'
      end

      def self.package_id_matchers
        [ /^.Z/, /^[HK].{10}$/ ]
      end
    end
  end
end
