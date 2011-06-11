require 'spec_helper'
require 'fakeweb'

USPS_TRACK_URL = %r|http://testing\.shippingapis\.com/.*|

describe Trackerific::USPS do
  include Fixtures
  
  before(:all) do
    @package_id = 'EJ958083578US'
    @usps = Trackerific::USPS.new :user_id => '123USERID4567'
  end
  
  describe "track_package" do
    context "with a successful response from the server" do
      before(:all) do
        FakeWeb.register_uri(
          :get,
          USPS_TRACK_URL,
          :body => load_fixture(:usps_success_response)
        )
        @valid_response = {
          :package_id => @package_id,
          :summary    => "Your item was delivered at 8:10 am on June 1 in Wilmington DE 19801.",
          :details    => [
            "May 30 11:07 am NOTICE LEFT WILMINGTON DE 19801.",
            "May 30 10:08 am ARRIVAL AT UNIT WILMINGTON DE 19850.",
            "May 29 9:55 am ACCEPT OR PICKUP EDGEWATER NJ 07020."
          ]
        }
      end
      specify { @usps.track_package(@package_id).should eq @valid_response }
    end
    context "with an error response from the server" do
      before(:all) do
        FakeWeb.register_uri(
          :get,
          USPS_TRACK_URL,
          :body => load_fixture(:usps_error_response)
        )
      end
      specify { lambda { @usps.track_package(@package_id) }.should raise_error(Trackerific::Error) }
    end
  end
    
end
