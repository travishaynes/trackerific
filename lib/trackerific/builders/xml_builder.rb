module Trackerific
  module Builders
    class XmlBuilder < Struct
      @xml_version = "1.0"

      class << self
        attr_accessor :xml_version
      end

      attr_reader :xml

      def initialize(*args)
        super(*args)
        @xml = ""
        build
      end

      protected

      def build
        raise NotImplementedError,
          "Implement this method in your builder subclass", caller
      end

      private

      def builder
        @builder ||= begin
          builder = ::Builder::XmlMarkup.new(target: @xml)
          builder.instruct! :xml, version: self.class.xml_version
          builder
        end
      end
    end
  end
end
