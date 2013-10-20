class TestConcernsXML < Trackerific::Services::Base
  include Trackerific::Services::Concerns::XML

  def initialize
    @credentials = { user_id: 'USER ID' }
  end
end

class TestConcernsSOAP < Trackerific::Services::Base
  include Trackerific::Services::Concerns::SOAP

  def initialize
    @credentials = { user_id: 'USER ID' }
  end
end
