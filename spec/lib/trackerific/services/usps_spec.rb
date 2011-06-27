require 'spec_helper'
require 'fakeweb'

USPS_URL = %r|http://testing\.shippingapis\.com/.*|

describe Trackerific::USPS do
  include Fixtures
  
  specify("it should descend from Trackerific::Service") {
    Trackerific::USPS.superclass.should be Trackerific::Service
  }
  
  describe :city_state_lookup do
    
    before(:all) do
      @usps = Trackerific::USPS.new :user_id => '123USERID4567'
    end
    
    context "with a successful response from the server" do
      
      before(:all) do
        FakeWeb.register_uri(:get, USPS_URL, :body => load_fixture(:usps_city_state_lookup_response))
      end
      
      before(:each) do
        @lookup = @usps.city_state_lookup("90210")
      end
      
      subject { @lookup }
      it { should include(:city) }
      it { should include(:state) }
      it { should include(:zip) }
      
    end
    
    context "with an error response from the server" do
      
      before(:all) do
        FakeWeb.register_uri(:get, USPS_URL, :body => load_fixture(:usps_error_response))
      end
      
      specify { lambda { @usps.city_state_lookup("90210") }.should raise_error(Trackerific::Error) }
      
    end
  end
  
  describe :track_package do
    
    before(:all) do
      @package_id = 'EJ958083578US'
      @usps = Trackerific::USPS.new :user_id => '123USERID4567'
    end
    
    context "with a successful response from the server" do
      
      before(:all) do
        FakeWeb.register_uri(:get, USPS_URL, :body => load_fixture(:usps_success_response))
      end
      
      before(:each) do
        @tracking = @usps.track_package(@package_id)
      end
      
      subject { @tracking }
      it("should return a Trackerific::Details") { should be_a Trackerific::Details }
      
      describe "events.length" do
        subject { @tracking.events.length }
        it { should >= 1 }
      end
      
      describe :summary do
        subject { @tracking.summary }
        it { should_not be_empty }
      end
      
    end
    
    pending "when use_city_state_lookup == true"
    
    context "with an error response from the server" do
      
      before(:all) do
        FakeWeb.register_uri(:get, USPS_URL, :body => load_fixture(:usps_error_response))
      end
      
      specify { lambda { @usps.track_package(@package_id) }.should raise_error(Trackerific::Error) }
      
    end
  end
  
  describe :required_parameters do
    subject { Trackerific::USPS.required_parameters }
    it { should include(:user_id) }
  end
  
  describe :valid_options do
    it "should include required_parameters" do
      valid = Trackerific::USPS.valid_options
      Trackerific::USPS.required_parameters.each do |opt|
        valid.should include opt
      end
    end
  end
  
  describe :package_id_matchers do
    subject { Trackerific::UPS.package_id_matchers }
    it("should be an Array of Regexp") { should each { |m| m.should be_a Regexp } }
  end
  
end
