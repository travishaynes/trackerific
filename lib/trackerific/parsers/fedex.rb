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
    track_details.map do |detail|
      Trackerific::Event.new(parse_date(detail), nil, location(detail))
    end
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
    @response.hash[:envelope][:body][:track_reply]
  end

  def track_details
    @track_details ||= begin
      details = track_reply[:completed_track_details][:track_details]
      details.select do |d|
        d[:ship_timestamp].present? && d[:destination_address].present? &&
        d[:destination_address][:city].present? &&
        d[:destination_address][:state_or_province_code].present?
      end
    end
  end

  def highest_severity
    track_reply[:highest_severity]
  end

  def notifications
    track_reply[:notifications]
  end
end
