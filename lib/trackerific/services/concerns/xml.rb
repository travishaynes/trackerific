module Trackerific
  module Services
    module Concerns
      module XML
        extend ActiveSupport::Concern

        included do
          @xml_builder_keys = []
          @xml_endpoint = ""
          @xml_parser = nil
          @xml_builder = nil
        end

        module ClassMethods
          attr_accessor :xml_endpoint
          attr_accessor :xml_parser
          attr_accessor :xml_builder
          attr_accessor :xml_builder_keys
        end

        # Gets the tracking information for the package from the server
        # @param [String] id The package identifier
        # @return [Trackerific::Details] The tracking details
        # @api semipublic
        def track(id)
          response = self.class.xml_parser.new(id, http_response(id)).result
          raise(response) if response.is_a?(Trackerific::Error)
          return response
        end

        protected

        def http_response(id)
          self.class.post(self.class.xml_endpoint, body: builder(id).xml)
        end

        def builder(id)
          options = @options.values_at(self.class.xml_builder_keys)
          options << id
          self.class.xml_builder.new(*options)
        end
      end
    end
  end
end
