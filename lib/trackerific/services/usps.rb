class Trackerific::Services::USPS < Trackerific::Services::Base
  register :usps, as: :XML

  configure do |config|
    config.parser = Trackerific::Parsers::USPS
    config.builder = Trackerific::Builders::USPS
    config.package_id_matchers = [ /^E\D{1}\d{9}\D{2}$|^9\d{15,21}$/ ]

    case Trackerific.env
    when 'production'
      config.endpoint = '/ShippingAPI.dll'
      config.base_uri = 'http://production.shippingapis.com'
    else
      config.endpoint = '/ShippingAPITest.dll'
      config.base_uri = 'http://testing.shippingapis.com'
    end
  end

  protected

  def request(id)
    self.class.get(config.endpoint, http_query(id))
  end

  def http_query(id)
    { query: { :API => 'TrackV2', :XML => builder(id).xml }.to_query }
  end
end
