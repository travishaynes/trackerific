module Trackerific
  module Services
    module Concerns
      module XML
        extend ActiveSupport::Concern

        included do
          include HTTParty
        end

        def track(id)
          response = config.parser.new(id, http_response(id)).parse
          raise(response) if response.is_a?(Trackerific::Error)
          return response
        end

        protected

        def http_response(id)
          self.class.post(config.endpoint, body: builder(id).xml)
        end

        def builder(id)
          members = config.builder.members - [:package_id]
          credentials = @credentials.values_at(*members)
          credentials << id
          config.builder.new(*credentials)
        end
      end
    end
  end
end
