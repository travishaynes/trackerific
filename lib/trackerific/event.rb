module Trackerific
  # Provides details for a tracking event
  class Event < Struct.new(:date, :description, :location)
    # Converts the event into a string
    # @example Get a human-readable string from an event
    #   event = details.event.to_s
    # @return [String] converts the event into a string
    # @api public
    def to_s
      [ date.strftime('%b %d %I:%M %P'),
        description,
        location
      ].join(" ")
    end
  end
end
