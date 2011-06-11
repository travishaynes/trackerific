require 'spec_helper'
require 'forgery'

FEDEX_TRACK_URL = "https://gatewaybeta.fedex.com/web-services/track"

describe "Trackerific::FedEx" do
  include Fixtures
  
  before(:all) do
    @package_id = "183689015000001"
    @fedex = Trackerific::FedEx.new :account  => Forgery::Basic.password,
                                    :meter    => Forgery::Basic.password,
                                    :key      => Forgery::Basic.password,
                                    :password => Forgery::Basic.password
  end
  
  describe "track_package" do
    pending "with a successful response from the server"
    pending "with an error response from the server"
  end
  
end
