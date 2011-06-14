require 'spec_helper'

describe "Trackerific" do
  include Trackerific
  
  describe "tracking_service" do
    
    context "when given a UPS tracking number" do
      specify { tracking_service("1Z12345E0291980793").should eq Trackerific::UPS }
    end
    
    context "when given a USPS tracking number" do
      specify { tracking_service("EJ958083578US").should eq Trackerific::USPS }
    end
    
    context "when given a FedEx tracking number" do
      specify { tracking_service("183689015000001").should eq Trackerific::FedEx }
    end
    
    context "when given an invalid tracking number" do
      specify { tracking_service("invalid tracking number").should be_nil }
    end
    
  end
  
end
