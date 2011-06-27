module Trackerific
  # Details returned when tracking a package. Stores the package identifier,
  # a summary, and the events.
  class Details
    include OptionsHelper
    
    # Provides a new instance of Details
    # @param [Hash] details The details for this package
    # @api private
    def initialize(details = {})
      required = [:package_id, :summary, :events]
      valid = required + [:weight, :via]
      validate_options(details, required, valid)
      @package_id = details[:package_id]
      @summary = details[:summary]
      @events = details[:events]
      @weight = details[:weight] || nil
      @via = details[:via] || nil
    end
    
    # The package identifier
    # @example Get the id of a tracked package
    #   details.package_id # => the package identifier
    # @return [String] the package identifier
    # @api public
    def package_id
      @package_id
    end
    
    # Summary of the package's tracking events
    # @example Get the summary of a tracked package
    #   details.summary # => Summary of the tracking events (i.e. Delivered)
    # @return [String] a summary of the tracking status
    # @api public
    def summary
      @summary
    end
    
    # The events for this package
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
    
    # The weight of the package (may not be supported by all services)
    # @example Get the weight of a package
    #   details.weight[:weight] # => the weight
    #   details.weight[:units]  # => the units of measurement for the weight (i.e. "LBS")
    # @return [Hash] Example: { units: 'LBS', weight: 19.1 }
    # @api public
    def weight
      @weight
    end
    
    # Example: UPS 2ND DAY AIR. May not be supported by all services
    # @example Get how the package was shipped
    #   ups = Trackerific::UPS.new :user_id => "userid"
    #   details = ups.track_package "1Z12345E0291980793"
    #   details.via # => "UPS 2ND DAY AIR"
    # @return [String] The service used to ship the package
    # @api public
    def via
      @via
    end
  end
end
