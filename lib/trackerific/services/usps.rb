require 'date'
require 'active_support/core_ext/object/to_query'

module Trackerific
  require 'builder'
  require 'httparty'
  
  # Provides package tracking support for USPS.
  class USPS < Trackerific::Service
    # setup HTTParty
    include HTTParty
    format :xml
    base_uri Rails.env.production? ? "http://production.shippingapis.com" : "http://testing.shippingapis.com"
    
    class << self
      # An Array of Regexp that matches valid USPS package IDs
      # @return [Array, Regexp] the regular expression
      # @api private
      def package_id_matchers
        [ /^E\D{1}\d{9}\D{2}$|^9\d{15,21}$/ ]
      end    
      
      # The required parameters for tracking a UPS package
      # @return [Array] the required parameters for tracking a UPS package
      # @api private
      def required_parameters
        [:user_id]
      end
      
      # List of all valid options for tracking a UPS package
      # @return [Array] the valid options for tracking a UPS package
      # @api private
      def valid_options
        required_parameters + [:use_city_state_lookup]
      end
    end
    
    # Tracks a USPS package
    # @param [String] package_id the package identifier
    # @return [Trackerific::Details] the tracking details
    # @raise [Trackerific::Error] raised when the server returns an error (invalid credentials, tracking package, etc.)
    # @example Track a package
    #   usps = Trackerific::USPS.new user_id: 'user'
    #   details = ups.track_package("EJ958083578US")
    # @api public    
    def track_package(package_id)
      super
      # connect to the USPS shipping API via HTTParty
      response = self.class.get(
        Rails.env.production? ? "/ShippingAPI.dll" : "/ShippingAPITest.dll",
        :query => {
          :API => 'TrackV2',
          :XML => build_tracking_xml_request
        }.to_query
      )
      # raise any errors
      error = check_response_for_errors(response, :TrackV2)
      raise error unless error.nil?
      # get the tracking information from the response, and convert into a
      # Trackerific::Details
      tracking_info = response['TrackResponse']['TrackInfo']
      events = []
      # check if we should look up the exact location of the details
      use_city_state_lookup = @options[:use_city_state_lookup] || false
      # parse the details
      tracking_info['TrackDetail'].each do |d|
        # each tracking detail is a string in this format:
        # MM DD HH:MM am/pm DESCRIPTION CITY STATE ZIP
        d = d.split(" ")
        date = DateTime.parse(d[0..3].join(" "))
        desc = d[4..d.length].join(" ")
        # the zip code is always the last word, if it is all numbers
        if use_city_state_lookup then
          # this gets the exact location of the package, and is very accurate,
          # however, it requires access to the shipping services in USPS
          zip = d[d.length-1]
          loc = ""
          # check if zip is a number
          if zip.to_i.to_s == zip
            loc = city_state_lookup(zip)
            loc = "#{loc[:city].titelize}, #{loc[:state]} #{loc[:zip]}"
            # attempt to delete the location from the description
            desc = desc.gsub("#{loc[:city]} #{loc[:state]} #{loc[:zip]}", "")
          end
        else
          # extract the location from the description - not always accurate,
          # but better than nothing
          d = desc.split(" ") # => ['the', 'description', 'city', 'state', 'zip']
          desc = d[0..d.length-4].join(" ") # => "the description"
          loc = d[d.length-3, d.length] # => ['city', 'state', 'zip']
          loc = "#{loc[0].titleize}, #{loc[1]} #{loc[2]}" # "City, STATE zip"
        end
        events << Trackerific::Event.new(
          :date         => date,
          :description  => desc.capitalize,
          :location     => loc
        )
      end unless tracking_info['TrackDetail'].nil?
      # return the details
      Trackerific::Details.new(
        :package_id => tracking_info['ID'],
        :summary    => tracking_info['TrackSummary'],
        :events     => events
      )
    end
    
    # Gets the city/state of a zipcode
    # @param [String] zipcode The zipcode to find the city/state for
    # @return [Hash] { zip: 'the zipcode, 'city: "the city", state: "the state" }
    # @example Lookup zipcode for Beverly Hills, CA
    #   usps = Trackerific::USPS.new :user_id => 'youruserid'
    #   city_state = usps.city_state_lookup(90210)
    #   city_state[:city]  # => BEVERLY HILLS
    #   city_state[:state] # => CA
    #   city_state[:zip]   # => 90210
    # @api public
    def city_state_lookup(zipcode)
      response = self.class.get(
        Rails.env.production? ? "/ShippingAPI.dll" : "/ShippingAPITest.dll",
        :query => {
          :API => 'CityStateLookup',
          :XML => build_city_state_xml_request(zipcode)
        }.to_query
      )
      # raise any errors
      error = check_response_for_errors(response, :CityStateLookup)
      raise error unless error.nil?
      # return the city, state, and zip
      response = response['CityStateLookupResponse']['ZipCode']
      {
        :city   => response['City'],
        :state  => response['State'],
        :zip    => response['Zip5']
      }
    end
    
    protected
    
    # Checks a HTTParty response for USPS, or HTTP errors
    # @param [HTTParty::Response] response The HTTParty response to check
    # @return The exception to raise, or nil
    # @api private
    def check_response_for_errors(response, api)
      # return any HTTP errors
      return response.error unless response.code == 200
      # return a Trackerific::Error if there is an error in the response, or if
      # the tracking response is malformed
      return Trackerific::Error.new(response['Error']['Description']) unless response['Error'].nil?
      return Trackerific::Error.new("Tracking information not found in response from server.") if response['TrackResponse'].nil? && api == :TrackV2
      return Trackerific::Error.new("City / state information not found in response from server.") if response['CityStateLookupResponse'].nil? && api == :CityStateLookup
      return nil # no errors to report
    end
    
    # Builds an XML city/state lookup request
    # @param [String] zipcode The zipcode to find the city/state for
    # @return [String] the xml request
    # @api private
    def build_city_state_xml_request(zipcode)
      xml = ""
      # set up the Builder
      builder = ::Builder::XmlMarkup.new(:target => xml)
      # add the XML header
      builder.instruct! :xml, :version => "1.0", :encoding => "UTF-8"
      # build the request
      builder.CityStateLookupRequest(:USERID => @options[:user_id]) do |request|
        request.ZipCode(:ID => "5") do |zip|
          zip.Zip5 zipcode
        end
      end
    end
    
    # Builds an XML tracking request
    # @return [String] the xml request
    # @api private
    def build_tracking_xml_request
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
