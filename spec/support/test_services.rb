class TestService < Trackerific::Services::Base
  self.register :test

  def self.package_id_matchers
    [ /^TEST$/ ]
  end

  def track(id)
    return Trackerific::Details.new
  end
end

class AnotherTestService < Trackerific::Services::Base
  self.register :another_test_service

  def self.package_id_matchers
    [ /^TEST$/ ]
  end

  def track(id)
    return Trackerific::Details.new
  end
end
