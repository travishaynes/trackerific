module Trackerific
  module Builders
    class UPS < Base::XML.new(:key, :user_id, :password, :package_id)
      protected

      def build
        add_access_request
        add_track_request
      end

      private

      def add_access_request
        builder.AccessRequest do |ar|
          ar.AccessLicenseNumber key
          ar.UserId user_id
          ar.Password password
        end
      end

      def add_track_request
        builder.TrackRequest do |tr|
          tr.Request do |r|
            r.RequestAction 'Track'
            r.RequestOption 'activity'
          end
          tr.TrackingNumber package_id
        end
      end
    end
  end
end
