require 'spec_helper'

describe Trackerific do
  include Trackerific
  
  describe :services do
    subject { Trackerific.services }
    it("should be an Array of Symbols") { should each { |m| m.should be_a Symbol } }
  end
  
  describe :service_get do
    
    context "with a valid service symbol" do
      subject { Trackerific.service_get(:fedex).superclass }
      it("should be a descendant of Trackerific::Service "){ should be Trackerific::Service }
    end
    
    context "with an invalid service symbol" do
      subject { Trackerific.service_get :ksjdfklsjdf }
      it { should be_nil }
    end
    
  end
  
  describe :tracking_service do
    
    context "when given a UPS tracking number" do
      subject { tracking_service "1Z12345E0291980793" }
      it { should be Trackerific::UPS}
    end
    
    context "when given a USPS tracking number" do
      subject { tracking_service "EJ958083578US" }
      it { should be Trackerific::USPS }
    end
    
    context "when given a FedEx tracking number" do
      subject { tracking_service "183689015000001" }
      it { should be Trackerific::FedEx }
    end
    
    context "when given an invalid tracking number" do
      subject { tracking_service "invalid tracking number" }
      it { should be_nil }
    end
    
  end
  
  describe :track_package do
    
    before do
      @details = track_package "XXXXXXXXXX"
    end
    
    subject { @details }
    
    it { should be_kind_of Trackerific::Details }
  end
  
end
