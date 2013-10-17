module Trackerific
  module Builders
    module Base
      class SOAP < Struct
        attr_reader :hash

        def initialize(*args)
          super(*args)
          @hash = build
        end

        protected

        def build
          raise NotImplementedError,
            "Implement this method in your builder subclass", caller
        end
      end
    end
  end
end
