module Trackerific
  module Builders
    class USPS < Base::XML.new(:user_id, :package_id)
      protected

      def build
        add_track_request
      end

      private

      def add_track_request
        builder.TrackRequest(:USERID => user_id) do |t|
          t.TrackID(:ID => package_id)
        end
      end
    end
  end
end
