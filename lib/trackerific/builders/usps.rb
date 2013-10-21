class Trackerific::Builders::USPS < Trackerific::Builders::Base::XML.new(
  :user_id, :package_id)

  protected

  # Builds the USPS track request XML
  # @api private
  def build
    add_track_request
  end

  private

  # Adds the track request and package id to the XML
  # @api private
  def add_track_request
    builder.TrackRequest(:USERID => user_id) do |t|
      t.TrackID(:ID => package_id)
    end
  end
end
