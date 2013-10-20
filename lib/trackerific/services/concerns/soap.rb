module Trackerific
  module Services
    module Concerns
      module SOAP
        extend ActiveSupport::Concern

        def track(id)
          response = config.parser.new(id, request(id)).parse
          response.is_a?(Trackerific::Error) ? raise(response) : response
        end

        protected

        def request(id)
          client.call(config.track_operation, message: builder(id).hash)
        end

        def builder(id)
          members = config.builder.members - [:package_id]
          credentials = @credentials.values_at(*members)
          credentials << id
          config.builder.new(*credentials)
        end

        def client
          @client ||= Savon.client(
            convert_request_keys_to: :camelcase,
            wsdl: Trackerific::SOAP::WSDL.path(config.wsdl))
        end
      end
    end
  end
end
