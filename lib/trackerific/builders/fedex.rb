module Trackerific
  module Builders
    class FedEx < XmlBuilder.new(:account, :meter, :package_id)
      protected

      def build
        namespace do |r|
          add_request_header(r)
          add_package_identifier(r)
        end
      end

      private

      def namespace(&block)
        builder.FDXTrack2Request \
          "xmlns:api" => "http://www.fedex.com/fsmapi",
          "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
          "xsi:noNamespaceSchemaLocation" => "FDXTrack2Request.xsd" \
        do |r| yield(r); end
      end

      def add_request_header(r)
        r.RequestHeader do |rh|
          rh.AccountNumber account
          rh.MeterNumber meter
        end
      end

      def add_package_identifier(r)
        r.PackageIdentifier do |pi|
          pi.Value package_id
        end
        r.DetailScans true
      end
    end
  end
end
