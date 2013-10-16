module Trackerific
  module Parsers
    class FedEx < XmlParser
      protected

      def response_error
        return false if track_reply["Error"].nil?
        Trackerific::Error.new(track_reply["Error"]["Message"])
      end

      def summary
        details["StatusDescription"]
      end

      def events
        details["Event"].map do |e|
          Trackerific::Event.new(
            parse_date_time(e), description(e), location(e))
        end
      end

      private

      def description(e)
        e["Description"]
      end

      def location(e)
        e["Address"].values_at('StateOrProvinceCode', 'PostalCode').join(" ")
      end

      def parse_date_time(e)
        DateTime.parse("#{e["Date"]} #{e["Time"]}")
      end

      def track_reply
        @response["FDXTrack2Reply"]
      end

      def details
        track_reply["Package"]
      end
    end
  end
end
