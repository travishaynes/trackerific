module Trackerific
  module Parsers
    class XmlParser
      attr_reader :result

      def initialize(package_id, response)
        @package_id = package_id
        @response = response
        @response.error! unless @response.code == 200
        @result = parse
      end

      protected

      def parse
        return response_error if response_error
        Trackerific::Details.new(@package_id, summary, events)
      end

      def response_error
        raise NotImplementedError,
          "Override this method in your parser subclass", caller
      end

      def summary
        raise NotImplementedError,
          "Override this method in your parser subclass", caller
      end

      def events
        raise NotImplementedError,
          "Override this method in your parser subclass", caller
      end
    end
  end
end
