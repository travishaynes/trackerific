# Provides a mock service for using in test and development
class Trackerific::Services::MockService < Trackerific::Services::Base
  require 'date'

  register :mock_service

  configure do |config|
    config.package_id_matchers = [ /XXXXXXXXXX/, /XXXxxxxxxx/ ]
  end

  def self.credentials
    {}
  end

  def track(id)
    if id == "XXXXXXXXXX"
      Trackerific::Details.new(id, "Your package was delivered.",
        [
          Trackerific::Event.new(
            :date         => Date.today,
            :description  => "Package delivered.",
            :location     => "SANTA MARIA, CA"
          ),
          Trackerific::Event.new(
            :date         => Date.today - 1,
            :description  => "Package scanned.",
            :location     => "SANTA BARBARA, CA"
          ),
          Trackerific::Event.new(
            :date         => Date.today - 2,
            :description  => "Package picked up for delivery.",
            :location     => "LOS ANGELES, CA"
          )
        ]
      )
    else
      raise Trackerific::Error, "Package not found."
    end
  end
end
