require 'spec_helper'

describe Trackerific::Services::FedEx do
  include Savon::SpecHelper

  let(:valid_ids) { ["183689015000001", "999999999999999"] }
  let(:invalid_ids) { %w[these are not valid tracking ids] }

  it "should match valid tracking ids" do
    valid_ids.all? {|id| described_class.can_track?(id) }.should be_true
  end

  it "should not match invalid tracking ids" do
    invalid_ids.all? {|id| described_class.can_track?(id) }.should be_false
  end

  let(:credentials) do
    { :key => "KEY",
      :password => "PASSWORD",
      :account_number => "ACCOUNT NUMBER",
      :meter_number => "METER NUMBER" }
  end

  let(:fedex) { described_class.new(credentials) }

  describe "#track" do
    before(:all) { savon.mock! }
    after(:all) { savon.unmock! }
    let(:hash) { double(:hash) }
    let(:package_id) { "PACKAGE ID" }

    before do
      Trackerific::Builders::FedEx.any_instance.stub(:hash).and_return(hash)
      savon.expects(:track).with(message: hash).returns(fixture)
    end

    subject { fedex.track(package_id) }

    context "with an error response" do
      let(:fixture) { Fixture.read('fedex/error.xml') }

      it "should raise a Trackerific::Error" do
        expect {
          subject
        }.to raise_error Trackerific::Error
      end
    end

    context "with a successful response" do
      let(:fixture) { Fixture.read('fedex/success.xml') }

      its(:package_id) { should eq package_id }
      its(:summary) { should be_nil }
      its(:weight) { should be_nil }
      its(:via) { should be_nil }

      describe "#events" do
        subject { fedex.track(package_id).events }
        its(:length) { should eq 5 }

        it "should populate its properties with values from the response" do
          subject.all? {|e| e.description.nil? }.should be_true
          subject.all? {|e| e.date.is_a?(DateTime) }.should be_true
          subject.map(&:location).should eq [
            "new york, NY US", "Memphis, TN US", "CITY OF INDUSTRY, CA US",
            "ST JACKSON, MS US", "Ontonagon, MI US" ]
        end
      end
    end
  end
end
