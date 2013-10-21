class Trackerific::Services::UPS < Trackerific::Services::Base
  register :ups, as: :XML

  configure do |config|
    config.endpoint = '/Track'
    config.parser = Trackerific::Parsers::UPS
    config.builder = Trackerific::Builders::UPS
    config.package_id_matchers = [ /^.Z/, /^[HK].{10}$/ ]
    config.base_uri = case Trackerific.env
    when 'production' then 'https://www.ups.com/ups.app/xml'
    else 'https://wwwcie.ups.com/ups.app/xml'
    end
  end
end
