require 'rails'

require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"
require "rails/test_unit/railtie"

module Trackerific
  class Application < Rails::Application
    config.encoding = 'utf-8'
  end
  
  Application.configure do
    config.cache_classes = true
    config.whiny_nils = true
    config.consider_all_requests_local = true
    config.action_controller.perform_caching = false
    config.action_dispatch.show_exceptions = false
    config.action_controller.allow_forgery_protection = false
    config.action_mailer.delivery_method = :test
    config.active_support.deprecation = :stderr
  end
end

Rails.env = 'test'
Trackerific::Application.initialize!
