module Trackerific
  # Provides details for a tracking event
  class Event
    # Provides a new instance of Event
    # @param [Time] the date / time of the event
    # @param [String] the event's description
    # @param [String] where the event took place
    def initialize(date, description, location)
      @date = date
      @description = description
      @location = location
    end
    
    # @return [Time] the date / time of the event
    def date
      @date
    end
    
    # @return [String] the event's description.
    def description
      @description
    end
    
    # @return [String] where the event took place (usually in City State Zip
    #   format)
    def location
      @location
    end
    
    # @return [String] converts the event into a string
    def to_s
      dte = self.date.strftime('%b %d %I:%M %P')
      des = self.description
      loc = self.location
      "#{dte} #{des} #{loc}"
    end
  end
end
