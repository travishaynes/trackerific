require 'spec_helper'

describe Trackerific::Services::Base do
  describe "#register" do
    it "should register the service" do
      # these classes were set up in support/test_services.rb
      Trackerific::Services[:test].should eq TestService
      Trackerific::Services[:another_test_service].should eq AnotherTestService
      TestService.name.should eq :test
      AnotherTestService.name.should eq :another_test_service
    end
  end
end
