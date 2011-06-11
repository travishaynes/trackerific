require 'spec_helper'
require 'fakeweb'

UPS_TRACK_URL = 'https://wwwcie.ups.com/ups.app/xml/Track'

describe "Trackerific::UPS" do
  include Fixtures
  
  before(:all) do
    @package_id = '1Z12345E0291980793'
    @ups = Trackerific::UPS.new :key => 'testkey', :user_id => 'testuser', :password => 'secret'
  end
  
  describe "track_package" do
    context "with a successful response from the server" do
      before(:all) do
        FakeWeb.register_uri(
          :post,
          UPS_TRACK_URL,
          :body => load_fixture(:ups_success_response)
        )
        @valid_response = {
          :package_id=>@package_id,
          :summary=>"Mar 13 04:00 pm DELIVERED",
          :details=>[]
        }
      end
      specify { @ups.track_package(@package_id).should eq @valid_response }
    end
    context "with an error response from the server" do
      before(:all) do
        FakeWeb.register_uri(
          :post,
          UPS_TRACK_URL,
          :body => load_fixture(:ups_error_response)
        )
      end
      specify { lambda { @ups.track_package("invalid package id") }.should raise_error(Trackerific::Error) }
    end
  end
end
