module Trackerific
  module Parsers
    class UPS < Parsers::Base
      protected

      def response_error
        @response_error ||= if @response.code != 200
          Trackerific::Error.new("HTTP returned status #{@response.code}")
        elsif response_status_code == :error
          Trackerific::Error.new(error_response)
        elsif response_status_code == :success
          false
        else
          Trackerific::Error.new("Unknown status code from server.")
        end
      end

      def summary
        description(activity.first)
      end

      def events
        activity.map do |a|
          date = parse_ups_date_time(a['Date'], a['Time'])
          Trackerific::Event.new(date, description(a), location(a))
        end
      end

      private

      def track_response
        @response['TrackResponse']
      end

      def response_status_code
        { "0" => :error,
          "1" => :success
        }[track_response['Response']['ResponseStatusCode']]
      end

      def error_response
        track_response['Response']['Error']['ErrorDescription']
      end

      def parse_ups_date_time(date, time)
        hours, minutes, seconds = time.scan(/.{2}/)
        DateTime.parse("#{Date.parse(date)} #{hours}:#{minutes}:#{seconds}")
      end

      def description(a)
        a['Status']['StatusType']['Description']
      end

      def location(a)
        a['ActivityLocation']['Address'].map {|k,v| v}.join(" ")
      end

      def activity
        @activity ||= begin
          a = track_response['Shipment']['Package']['Activity']
          a.is_a?(Array) ? a : [a]
        end
      end
    end
  end
end
