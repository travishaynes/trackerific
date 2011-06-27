require 'spec_helper'

describe Trackerific::MockService do

  specify("it should descend from Trackerific::Service") {
    Trackerific::MockService.superclass.should be Trackerific::Service
  }
  
  describe :required_parameters do
    subject { Trackerific::MockService.required_parameters }
    it { should be_empty }
  end
  
  describe :package_id_matchers do
  
    context "when in development or test mode" do
      subject { Trackerific::MockService.package_id_matchers }
      it("should be an Array of Regexp") { should each { |m| m.should be_a Regexp } }
    end
    
    context "when in production mode" do
      before { Rails.env = "production" }
      subject { Trackerific::MockService.package_id_matchers }
      it { should be_empty }
      after { Rails.env = "test"}
    end
  end
  
  describe :track_package do
    before(:all) do
      @service = Trackerific::MockService.new
    end
    
    context "with valid package_id" do
      before { @tracking = @service.track_package("XXXXXXXXXX") }
      subject { @tracking }
      it("should return a Trackerific::Details") { should be_a Trackerific::Details }
      
      describe "events.length" do
        subject { @tracking.events.length }
        it { should >= 1}
      end
      
      describe :summary do
        subject { @tracking.summary }
        it { should_not be_empty }
      end
    end
    
    context "with invalid package_id" do
      specify { lambda { @service.track_package("XXXxxxxxxx") }.should raise_error(Trackerific::Error) }
    end
    
  end
  
end
