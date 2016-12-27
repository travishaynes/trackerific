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
    description(activity.first)
  end

  def events
    activity.map do |event|
      Trackerific::Event.new parse_date(event), description(event), location(event)
    end
  end

  private

  def description(event)
    event[:event_description]
  end

  def location(event)
    a = event[:address]
    "#{a[:city]}, #{a[:state_or_province_code]} #{a[:country_code]}"
  end

  def parse_date(event)
    event[:timestamp]
  end

  def track_reply
    @response.hash[:envelope][:body][:track_reply]
  end

  def track_details
    @track_details ||= track_reply[:completed_track_details][:track_details]
  end

  def activity
    @activity ||= begin
      a = track_details[:events]
      a.is_a?(Array) ? a : [a]
    end
  end

  def highest_severity
    track_reply[:highest_severity]
  end

  def notifications
    track_reply[:notifications]
  end
end

