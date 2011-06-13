require 'date'

module Trackerific
  require 'builder'
  require 'httparty'
  
  # Provides package tracking support for USPS.
  class USPS < Base
    # setup HTTParty
    include HTTParty
    format :xml
    # use the test site for Rails development, production for everything else
    base_uri defined?(Rails) ? case Rails.env
      when 'test', 'development' then 'http://testing.shippingapis.com'
      when 'production' then 'https://secure.shippingapis.com'
    end : 'https://secure.shippingapis.com'
    
    # The required option for tracking a UPS package is :user_id
    #
    # @return [Array] the required options for tracking a UPS package.
    def required_options
      [:user_id]
    end
    
    # Tracks a USPS package.
    # A Trackerific::Error is raised when a package cannot be tracked.
    # @return [Trackerific::Details] the tracking details
    def track_package(package_id)
      super
      # connect to the USPS shipping API via HTTParty
      response = self.class.get('/ShippingAPITest.dll', :query => {:API => 'TrackV2', :XML => build_xml_request}.to_query)
      # throw any HTTP errors
      response.error! unless response.code == 200
      # raise a Trackerific::Error if there is an error in the response, or if the
      # tracking response is malformed
      raise Trackerific::Error, response['Error']['Description'] unless response['Error'].nil?
      raise Trackerific::Error, "Tracking information not found in response from server." if response['TrackResponse'].nil?
      # get the tracking information from the response, and convert into a
      # Trackerific::Details
      tracking_info = response['TrackResponse']['TrackInfo']
      details = []
      tracking_info['TrackDetail'].each do |d|
        # each tracking detail is a string in this format:
        # MM DD HH:MM am/pm DESCRIPTION CITY STATE ZIP.
        # unfortunately, it will not be possible to tell the difference between
        # the location, and the summary. So, for USPS, the location will be in
        # the summary
        d = d.split(" ")
        date = DateTime.parse(d[0..3].join(" "))
        desc = d[4..d.length].join(" ")
        details << Trackerific::Event.new(date, desc, "")
      end
      # return the details
      Trackerific::Details.new(
        tracking_info['ID'],
        tracking_info['TrackSummary'],
        details
      )
    end
    
    protected
    
    # Builds an XML request to send to USPS
    # @return [String] the xml request
    def build_xml_request
      xml = ""
      # set up the Builder
      builder = ::Builder::XmlMarkup.new(:target => xml)
      # build the request
      builder.TrackRequest(:USERID => @options[:user_id]) do |t|
        t.TrackID(:ID => @package_id)
      end
      # return the XML
      xml
    end
    
  end
  
end
