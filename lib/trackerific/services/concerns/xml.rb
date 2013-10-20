module Trackerific
  module Services
    module Concerns
      module XML
        extend ActiveSupport::Concern

        included do
          include HTTParty

          format :xml
        end

        module ClassMethods
          def configure(&block)
            super
            base_uri(config.base_uri)
          end
        end

        protected

        def request(id)
          self.class.post(config.endpoint, body: builder(id).xml)
        end
      end
    end
  end
end
