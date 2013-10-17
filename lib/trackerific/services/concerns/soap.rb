module Trackerific
  module Services
    module Concerns
      module SOAP
        extend ActiveSupport::Concern

        included do
          @soap_track_operation = :track
          @soap_builder = nil
          @soap_parser = nil
          @soap_wsdl = ""
        end

        module ClassMethods
          attr_accessor :soap_track_operation
          attr_accessor :soap_builder
          attr_accessor :soap_parser
          attr_accessor :soap_wsdl
        end

        def track(id)
          operation = self.class.soap_track_operation
          request = client.call(operation, message: builder(id).hash)
          response = self.class.soap_parser.new(id, request).parse
          raise(response) if response.is_a?(Trackerific::Error)
          return response
        end

        protected

        def builder(id)
          members = self.class.soap_builder.members - [:package_id]
          credentials = @credentials.values_at(members)
          credentials << id
          self.class.soap_builder.new(*credentials)
        end

        def client
          @client ||= begin
            path = Trackerific::SOAP::WSDL.path(self.class.soap_wsdl)
            Savon.client(wsdl: path)
          end
        end
      end
    end
  end
end
