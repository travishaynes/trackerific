module Trackerific
  module Services
    module Concerns
      module SOAP
        extend ActiveSupport::Concern

        protected

        def request(id)
          client.call(config.track_operation, message: builder(id).hash)
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
