module Trackerific
  require 'xmlsimple'
  require 'httparty'
  
  class UPS < Base
    TEST_TRACKING_NUMBERS = [
      '1Z12345E0291980793', '1Z12345E6692804405','1Z12345E1392654435',
      '1Z12345E6892410845','1Z12345E029198079','1Z12345E1591910450'
    ]
    
    def required_options
      [:key, :user_id, :password]
    end
    
    def track_package(package_id)
      super
      http_response = HTTP.post('/Track', :body => build_xml_request)
      http_response.error! unless http_response.code == 200
      case http_response['TrackResponse']['Response']['ResponseStatusCode']
        when "0" then raise Trackerific::Error, parse_error_response(http_response)
        when "1" then return parse_success_response(http_response)
        else raise Trackerific::Error, "Invalid response code returned from server."
      end
    end
    
    protected
    
    def parse_success_response(http_response)
      activity = http_response['TrackResponse']['Shipment']['Package']['Activity']
      activity = [activity] if activity.is_a? Hash
      details = []
      activity.each do |a|
        status = a['Status']['StatusType']['Description']
        if status != "UPS INTERNAL ACTIVITY CODE"
          address = a['ActivityLocation']['Address'].map {|k,v| v}.join(" ")
          date = "#{a['Date'].to_date} #{a['Time'][0..1]}:#{a['Time'][2..3]}:#{a['Time'][4..5]}".to_datetime
          details << "#{date.strftime('%b %d %I:%M %P')} #{status}"
        end
      end
      # UPS does not provide a summary, so just use the last tracking details
      summary = details.last
      details.delete(summary)
      return {
        :package_id => @package_id,
        :summary => summary,
        :details => details.reverse
      }
    end
    
    def parse_error_response(http_response)
      http_response['TrackResponse']['Response']['Error']['ErrorDescription']
    end
    
    def build_xml_request
      xml = ""
      builder = ::Builder::XmlMarkup.new(:target => xml)
      builder.AccessRequest do |ar|
        ar.AccessLicenseNumber @options[:key]
        ar.UserId @options[:user_id]
        ar.Password @options[:password]
      end
      builder.TrackRequest do |tr|
        tr.Request do |r|
          r.RequestAction 'Track'
        end
        tr.TrackingNumber @package_id
      end
      return xml
    end
    
    private
    
    class HTTP
      include ::HTTParty
      format :xml
      base_uri case Rails.env
        when 'test' then 'mock://mock.ups.com/ups.app/xml'
        when 'development' then 'https://wwwcie.ups.com/ups.app/xml'
        when 'production' then 'https://www.ups.com/ups.app/xml'
      end
    end
  end
end
