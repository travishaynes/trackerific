require 'spec_helper'

describe Trackerific::Services::FedEx do
#  include Savon::SpecHelper

#  before(:all) { savon.mock! }
#  after(:all) { savon.unmock! }

#  let(:credentials) do
#    { :key            => "KEY",
#      :password       => "PASSWORD",
#      :account_number => "ACCOUNT NUMBER",
#      :meter_number   => "METER NUMBER" }
#  end

#  let(:service) { described_class.new(credentials) }

#  let(:id) { "183689015000001" }

#  describe "#track" do
#    subject { service.track(id) }

#    let(:message) do
#      {:WebAuthenticationDetail=>{:UserCredential=>{:Key=>nil, :Password=>"183689015000001"}}, :ClientDetails=>{:AccountNumber=>nil, :MeterNumber=>nil}, :TransactionDetail=>{:CustomerTransactionId=>"eeeaf8f4798ce6ad"}, :Version=>{:ServiceId=>"trck", :Major=>"7", :Intermediate=>"0", :Minor=>"0"}, :SelectionDetails=>{:CarrierCode=>"FDXE", :PackageIdentifier=>{:Type=>"TRACKING_NUMBER_OR_DOORTAG", :Value=>id}}, :ProcessingOptions=>"INCLUDE_DETAILED_SCANS"}
#    end

#    before do
#      Trackerific::Builders::FedEx.any_instance.stub(:hash).and_return(message)
#      savon.expects(:track).with(message: message).returns(fixture)
#    end

#    context "with an error response" do
#      let(:fixture) { Fixture.read('fedex/v8/error.xml') }

#      specify { p subject }
#    end

#    context "with a successful response" do
#      let(:fixture) { Fixture.read('fedex/v8/success.xml') }
#    end
#  end
end

#FEDEX_TRACK_URL = "https://gateway.fedex.com/GatewayDC"

#describe Trackerific::Services::FedEx do
#  it { should be_a Trackerific::Services::Base }

#  it "should be registered" do
#    Trackerific::Services[:fedex].should eq Trackerific::Services::FedEx
#    described_class.name.should eq :fedex
#  end

#  let(:valid_ids) { ["183689015000001", "999999999999999"] }
#  let(:invalid_ids) { %w[these are not fedex tracking ids] }

#  it "should match valid FedEx ids" do
#    valid_ids.all? {|id| described_class.can_track?(id) }.should be_true
#  end

#  it "should not match invalid FedEx ids" do
#    invalid_ids.all? {|id| described_class.can_track?(id) }.should be_false
#  end

#  describe "#track" do
#    let(:id) { "183689015000001" }
#    let(:credentials) { { account: "123456789", meter: "123456789" } }
#    let(:fedex) { described_class.new(credentials) }

#    before do
#      FakeWeb.register_uri(:post, FEDEX_TRACK_URL, body: fixture)
#    end

#    after { FakeWeb.clean_registry }

#    context "with a successful response" do
#      let(:fixture) { Fixture.read('fedex/success.xml') }
#      subject { fedex.track(id) }
#      it { should be_a Trackerific::Details }
#      its(:package_id) { should eq id }
#      its(:summary) { should eq "Delivered" }

#      describe "#events" do
#        subject { fedex.track(id).events }
#        its(:length) { should eq 3 }

#        it "should be an Array of Trackerific::Event" do
#          subject.all? {|el| el.is_a?(Trackerific::Event) }.should be_true
#        end

#        it "should have the correct event values" do
#          subject[0].date.to_s.should eq "2010-07-01T10:43:51+00:00"
#          subject[0].description.should eq "Delivered"
#          subject[0].location.should eq "GA 30506"
#          subject[1].date.to_s.should eq "2010-07-01T08:48:00+00:00"
#          subject[1].description.should eq "On FedEx vehicle for delivery"
#          subject[1].location.should eq "GA 30601"
#          subject[2].date.to_s.should eq "2010-07-01T05:07:00+00:00"
#          subject[2].description.should eq "At local FedEx facility"
#          subject[2].location.should eq "GA 30601"
#        end
#      end
#    end

#    context "with an error response" do
#      let(:fixture) { Fixture.read('fedex/error.xml') }
#      it "should raise a Trackerific::Error" do
#        expect {
#          fedex.track(id)
#        }.to raise_error Trackerific::Error
#      end
#    end
#  end
#end
