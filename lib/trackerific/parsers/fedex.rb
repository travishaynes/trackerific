class Trackerific::Parsers::FedEx < Trackerific::Parsers::Base
  protected

  def response_error
    @response_error ||= if highest_severity == 'ERROR'
      Trackerific::Error.new(notifications[:message])
    else
      false
    end
  end

  def summary
    nil
  end

  def events
    # FIXME: The API has changed, this needs to be updated
    #track_details[:events].map do |event|
      # Trackerific::Event.new(parse_date(detail), nil, location(detail))
    #end
  end

  private

  def location(detail)
    a = detail[:destination_address]
    "#{a[:city]}, #{a[:state_or_province_code]} #{a[:country_code]}"
  end

  def parse_date(detail)
    detail[:ship_timestamp]
  end

  def track_reply
    @response.hash[:track_reply]
  end

  def track_details
    @track_details ||= track_reply[:completed_track_details][:track_details]
  end

  def highest_severity
    track_reply[:highest_severity]
  end

  def notifications
    track_reply[:notifications]
  end
end

