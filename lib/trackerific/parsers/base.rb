module Trackerific
  module Parsers
    class Base
      def initialize(package_id, response)
        @package_id = package_id
        @response = response
      end

      def parse
        @result ||= if response_error
          response_error
        else
          Trackerific::Details.new(@package_id, summary, events)
        end
      end

      protected

      def response_error
        raise NotImplementedError,
          "Override this method in your parser", caller
      end

      def summary
        raise NotImplementedError,
          "Override this method in your parser", caller
      end

      def events
        raise NotImplementedError,
          "Override this method in your parser", caller
      end
    end
  end
end
