class Trackerific::Services::Base
  class << self
    attr_accessor :name
    attr_accessor :config

    # Configures the service
    # @api semipublic
    def configure(&block)
      yield self.config = OpenStruct.new
    end

    # Includes the service concerns for the given service type
    # @param [Symbol] service_type The module name for the service type
    # @api semipublic
    def concerns(service_type)
      self.send :include,
        "Trackerific::Services::Concerns::#{service_type}".constantize
    end

    # Registers the service with Trackerific
    # @api semipublic
    def register(name, options={})
      concerns(options[:as]) if options[:as].present?
      self.name = name.to_sym
      Trackerific::Services[self.name] = self
    end

    # Creates a new instance and calls #track with the given id
    # @param id The package identifier
    # @return Either a Trackerific::Details or Trackerific::Error
    def track(id)
      new.track(id)
    end

    # Reads the credentials from Trackerific.config
    # @return [Hash] The service's credentials
    def credentials
      Trackerific.config[name]
    end

    # Checks if the given package ID can be tracked by this service
    # @param [String] id The package ID
    # @return [Boolean] true when this service can track the given ID
    # @note This will always be false if no credentials were found for the
    # service in Trackerific.config
    def can_track?(id)
      return false if credentials.nil?
      package_id_matchers.each {|m| return true if id =~ m }
      false
    end

    # An Array of Regexp that matches valid package ids for the service
    # @api semipublic
    def package_id_matchers
      config.package_id_matchers
    end
  end

  def initialize(credentials=self.class.credentials)
    @credentials = credentials

    if credentials.nil?
      raise Trackerific::Error,
        "Missing credentials for #{self.class.name}", caller
    end
  end

  def config
    self.class.config
  end

  def track(id)
    result = config.parser.new(id, request(id)).parse
    result.is_a?(Trackerific::Error) ? raise(result) : result
  end

  protected

  def builder(id)
    members = config.builder.members - [:package_id]
    credentials = @credentials.values_at(*members)
    credentials << id
    config.builder.new(*credentials)
  end
end
