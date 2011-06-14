module Trackerific
  # Details returned when tracking a package. Stores the package identifier,
  # a summary, and the events.
  class Details
    # Provides a new instance of Details
    # @param [String] package_id the package identifier
    # @param [String] summary a summary of the tracking status
    # @param [Array, Trackerific::Event] events the tracking events
    # @api private
    def initialize(package_id, summary, events)
      @package_id = package_id
      @summary = summary
      @events = events
    end
    
    # Read-only string for the package identifier
    # @example Get the id of a tracked package
    #   details.package_id # => the package identifier
    # @return [String] the package identifier
    # @api public
    def package_id
      @package_id
    end
    
    # Read-only string for the summary of the package's tracking events
    # @example Get the summary of a tracked package
    #   details.summary # => Summary of the tracking events (i.e. Delivered)
    # @return [String] a summary of the tracking status
    # @api public
    def summary
      @summary
    end
    
    # Read-only string for the events for this package
    # @example Print all the events for a tracked package
    #   puts details.events
    # @example Get the date the package was shipped
    #   details.events.last.date # => a DateTime value
    # @example A bulleted HTML list of the events (most current on top) in haml
    #   %ul
    #     - details.events.each do |event|
    #       %li= event
    # @return [Array, Trackerific::Event] the tracking events
    # @api public
    def events
      @events
    end
  end
end
