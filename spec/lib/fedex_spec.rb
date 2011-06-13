require 'spec_helper'
require 'fakeweb'

FEDEX_TRACK_URL = "https://gateway.fedex.com/GatewayDC"

describe "Trackerific::FedEx" do
  include Fixtures
  
  before(:all) do
    @package_id = "183689015000001"
    @fedex = Trackerific::FedEx.new :account  => "123456789", :meter => "123456789"
  end
  
  describe "track_package" do
    context "with a successful response from the server" do
      before(:each) do
        FakeWeb.register_uri(
          :post,
          FEDEX_TRACK_URL,
          :body => load_fixture(:fedex_success_response)
        )
        @valid_response = {
          :package_id => "183689015000001",
          :summary    => "Delivered",
          :details    => [
            "Jul 01 10:43 am Delivered Gainesville GA 30506",
            "Jul 01 08:48 am On FedEx vehicle for delivery ATHENS GA 30601",
            "Jul 01 05:07 am At local FedEx facility ATHENS GA 30601"
          ]
        }
      end
      specify { @fedex.track_package(@package_id).should eq @valid_response }
    end
    context "with an error response from the server" do
      before(:all) do
        FakeWeb.register_uri(
          :post,
          FEDEX_TRACK_URL,
          :body => load_fixture(:fedex_error_response)
        )
      end
      specify { lambda { @fedex.track_package("invalid package id") }.should raise_error(Trackerific::Error) }
    end
  end
  
end
