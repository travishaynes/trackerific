require 'spec_helper'
require 'fakeweb'

FEDEX_TRACK_URL = "https://gateway.fedex.com/GatewayDC"

describe "Trackerific::FedEx" do
  include Fixtures
  
  describe :required_options do
    subject { Trackerific::FedEx.required_options }
    it { should include(:account) }
    it { should include(:meter) }
  end
  
  describe :package_id_matchers do
    subject { Trackerific::FedEx.package_id_matchers }
    it("should be an Array of Regexp") { should each { |m| m.should be_a Regexp } }
  end
  
  describe :track_package do
    before(:all) do
      @package_id = "183689015000001"
      @fedex = Trackerific::FedEx.new :account  => "123456789", :meter => "123456789"
    end
    
    context "with a successful response from the server" do
      
      before(:all) do
        FakeWeb.register_uri(:post, FEDEX_TRACK_URL, :body => load_fixture(:fedex_success_response))
      end
      
      before(:each) do
        @tracking = @fedex.track_package(@package_id)
      end
      
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
    
    context "with an error response from the server" do
      
      before(:all) do
        FakeWeb.register_uri(:post, FEDEX_TRACK_URL, :body => load_fixture(:fedex_error_response))
      end
      
      specify { lambda { @fedex.track_package("invalid package id") }.should raise_error(Trackerific::Error) }
      
    end
    
  end
  
end
