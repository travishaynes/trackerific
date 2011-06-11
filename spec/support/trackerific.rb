# Provides a Rails application environment to use when running the specs.

require 'rails'

require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"

module Trackerific
  class Application < Rails::Application
    config.encoding = 'utf-8'
  end
  
  Application.configure do
    config.active_support.deprecation = :stderr
  end
end

puts "Loading Rails environment ..."
Rails.env = 'test'
Trackerific::Application.initialize!
