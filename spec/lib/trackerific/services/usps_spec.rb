require 'spec_helper'
require 'fakeweb'

USPS_TRACK_URL = %r|http://testing\.shippingapis\.com/.*|

describe Trackerific::USPS do
  include Fixtures
  
  describe :required_options do
    subject { Trackerific::USPS.required_options }
    it { should include(:user_id) }
  end
  
  describe :package_id_matchers do
    it "should be an Array of Regexp" do
      Trackerific::UPS.package_id_matchers.should each { |m| m.should be_a Regexp }
    end
  end
  
  describe :track_package do
    before(:all) do
      @package_id = 'EJ958083578US'
      @usps = Trackerific::USPS.new :user_id => '123USERID4567'
    end
    
    context "with a successful response from the server" do
      before(:all) do
        FakeWeb.register_uri(:get, USPS_TRACK_URL, :body => load_fixture(:usps_success_response))
        @tracking = @usps.track_package(@package_id)
      end
      specify { @tracking.should be_a Trackerific::Details }
      it "should have at least one event" do
        @tracking.events.length.should >= 1
      end
      it "should have a summary" do
        @tracking.summary.should_not be_empty
      end
    end
    
    context "with an error response from the server" do
      before(:all) do
        FakeWeb.register_uri(:get, USPS_TRACK_URL, :body => load_fixture(:usps_error_response))
      end
      specify { lambda { @usps.track_package(@package_id) }.should raise_error(Trackerific::Error) }
    end
  end
    
end
