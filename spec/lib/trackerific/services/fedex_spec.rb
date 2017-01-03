require 'spec_helper'

describe Trackerific::Services::FedEx do
  include Savon::SpecHelper

  let(:valid_ids) {
    [ "123456789012", "123456789012345", "9612345678901234567890",
      "98123456 1234 1234", "9812 1234 1234", "98123456 1234 1234 123",
      "9812 1234 1234 123" ]
  }

  let(:invalid_ids) {
    [ "1234567890123456", "1234567890", "96123456789012345678901",
      "961234567890123456789", "9812345 1234 1234", "981234567 1234 1234",
      "981 1234 1234", "98123 1234 1234", "981234567 1234 1234 123",
      "9812345 1234 1234 123", "981 1234 1234 123", "98123 1234 1234 123",
      "1Z12345E0291980793", "EJ958083578US", "XXXXXXXXXX" ]
  }

  it "should match valid tracking ids", :wip do
    valid_ids.all? {|id| described_class.can_track?(id) }.should be_true
  end

  it "should not match invalid tracking ids", :wip do
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
      its(:summary) { should eq "Delivered" }
      its(:weight) { should be_nil }
      its(:via) { should be_nil }

      describe "#events" do
        subject { fedex.track(package_id).events }
        its(:length) { should eq 1 }

        it "should populate its properties with values from the response" do
          subject.all? {|e| e.description.nil? }.should be_false
          subject.all? {|e| e.date.is_a?(DateTime) }.should be_true
          subject.map(&:location).should eq ["Prov, RI US"]
        end
      end
    end
  end
end

