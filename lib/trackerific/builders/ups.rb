class Trackerific::Builders::UPS < Trackerific::Builders::Base::XML.new(
  :key, :user_id, :password, :package_id)

  protected

  # Builds the UPS track request XML
  # @api private
  def build
    add_access_request
    add_track_request
  end

  private

  # Adds the user credentials to the XML
  # @api private
  def add_access_request
    builder.AccessRequest do |ar|
      ar.AccessLicenseNumber key
      ar.UserId user_id
      ar.Password password
    end
  end

  # Adds the track request and package id to the XML
  # @api private
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
