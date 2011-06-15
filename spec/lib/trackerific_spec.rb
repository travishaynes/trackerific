require 'spec_helper'

describe "Trackerific" do
  include Trackerific
  
  describe "tracking_service" do
    
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
  
end
