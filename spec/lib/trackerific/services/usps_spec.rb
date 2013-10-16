require 'spec_helper'

USPS_URL = %r|http://testing\.shippingapis\.com/.*|

describe Trackerific::Services::USPS do
  it { should be_a Trackerific::Services::Base }

  let(:valid_ids) { ["EJ958083578US"] }
  let(:invalid_ids) { %w[these are not valid tracking ids] }

  it "should match valid tracking ids" do
    valid_ids.all? {|id| described_class.can_track?(id) }.should be_true
  end

  it "should not match invalid tracking ids" do
    invalid_ids.all? {|id| described_class.can_track?(id) }.should be_false
  end

  let(:credentials) { { user_id: '123USERID4567' } }
  let(:usps) { described_class.new(credentials) }

  describe "#track" do
    let(:id) { 'EJ958083578US' }

    before do
      FakeWeb.register_uri(:get, USPS_URL, body: fixture)
    end

    after(:all) { FakeWeb.clean_registry }

    context "with a successful response" do
      let(:fixture) { Fixture.read('usps/success.xml') }

      subject { usps.track(id) }

      it { should be_a Trackerific::Details }

      its(:package_id) { should eq id }
      its(:summary) { should eq "Your item was delivered at 8:10 am on June 1 in Wilmington DE 19801." }
      its(:events) { should be_a Array }
      its(:weight) { should be_nil }
      its(:via) { should be_nil }

      describe "#events" do
        subject { usps.track(id).events }
        its(:length) { should eq 3 }
        it "should have the correct values" do
          subject[0].date.to_s.should eq "2013-05-30T11:07:00+00:00"
          subject[0].description.should eq "NOTICE LEFT"
          subject[0].location.should eq "WILMINGTON, DE 19801"
          subject[1].date.to_s.should eq "2013-05-30T10:08:00+00:00"
          subject[1].description.should eq "ARRIVAL AT UNIT"
          subject[1].location.should eq "WILMINGTON, DE 19850"
          subject[2].date.to_s.should eq "2013-05-29T09:55:00+00:00"
          subject[2].description.should eq "ACCEPT OR PICKUP"
          subject[2].location.should eq "EDGEWATER, NJ 07020"
        end
      end
    end

    context "with an error response" do
      let(:fixture) { Fixture.read('usps/error.xml') }
      it "should raise a Trackerific::Error" do
        expect {
          usps.track(id)
        }.to raise_error Trackerific::Error
      end
    end
  end
end
