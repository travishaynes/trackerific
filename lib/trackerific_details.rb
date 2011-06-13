module Trackerific
  # Details returned when tracking a package. Stores the package identifier,
  # a summary, and the events.
  class Details
    # Provides a new instance of Details
    # @param [String] the package identifier
    # @param [String] a summary of the tracking status
    # @param [Array, Trackerific::Event] the tracking events
    def initialize(package_id, summary, events)
      @package_id = package_id
      @summary = summary
      @events = events
    end
    
    # @return [String] the package identifier
    def package_id
      @package_id
    end
    
    # @return [String] a summary of the tracking status
    def summary
      @summary
    end
    
    # @return [Array, Trackerific::Event] the tracking events
    def events
      @events
    end
  end
end
