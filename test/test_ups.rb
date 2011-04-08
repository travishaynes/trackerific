require 'helper'
require 'fakeweb'
require 'trackerific'

class TestUPS < Test::Unit::TestCase
  UPS_TRACK_URL = 'https://wwwcie.ups.com/ups.app/xml/Track'
  context 'ups' do
    setup do
      @package_id = '1Z12345E0291980793'
      @ups = Trackerific::UPS.new :key => 'testkey', :user_id => 'testuser', :password => 'secret'
    end
      
    should "return a successful tracking response" do
      FakeWeb.register_uri(:post, UPS_TRACK_URL, :body => load_fixture(:ups_success))
      tracking_response = @ups.track_package(@package_id)
      assert_equal tracking_response, {
        :package_id=>"1Z12345E0291980793",
        :summary=>"Mar 13 04:00 pm DELIVERED",
        :details=>[] # TODO: add details to the success response
      }
    end
    
    should "raise a Trackerific:Error exception" do
      FakeWeb.register_uri(:post, UPS_TRACK_URL, :body => load_fixture(:ups_error))
      assert_raises Trackerific::Error do
        tracking_response = @ups.track_package(@package_id)
      end
    end
  end
end
