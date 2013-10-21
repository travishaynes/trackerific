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
      Trackerific::Details.new(id, "Your package was delivered.", events)
    else
      raise Trackerific::Error, "Package not found."
    end
  end

  private

  def events
    [ [Date.today, "Package delivered.", "SANTA MARIA, CA"],
      [Date.today - 1, "Package scanned.", "SANTA BARBARA, CA"],
      [Date.today - 2, "Package picked up for delivery.", "LOS ANGELES, CA"]
    ].map do |event|
      Trackerific::Event.new(*event)
    end
  end
end
