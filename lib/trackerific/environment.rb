module Trackerific
  class << self
    def env
      @env || ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'development'
    end

    def env=(value)
      @env = value
    end
  end
end
