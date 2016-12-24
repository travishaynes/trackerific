require 'spec_helper'

describe Trackerific::Services::USPS do
  let(:usps_url) { %r|http://testing\.shippingapis\.com/.*| }

  it { should be_a Trackerific::Services::Base }

  describe "environment dependent methods/properties" do
    before do
      Trackerific.stub(:env).and_return(env)
      Trackerific.reload!('trackerific/services/usps.rb')
    end

    after(:all) { Trackerific.reload!('trackerific/services/usps.rb') }

    context "when Trackerific.env is 'production'" do
      let(:env) { 'production' }

      describe "#base_uri" do
        subject { described_class.base_uri }
        it { should eq 'http://production.shippingapis.com' }
      end

      describe "#config.xml_endpoint" do
        subject { described_class.config.endpoint }
        it { should eq '/ShippingAPI.dll' }
      end
    end

    context "when Trackerific.env is not 'production'" do
      let(:env) { 'development' }

      describe "#base_uri" do
        subject { described_class.base_uri }
        it { should eq 'http://testing.shippingapis.com' }
      end

      describe "#config.xml_endpoint" do
        subject { described_class.config.endpoint }
        it { should eq '/ShippingAPITest.dll' }
      end
    end
  end

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
      FakeWeb.register_uri(:get, usps_url, body: fixture)
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
        it "should populate the properties from the XML" do
          year = Date.today.year
          subject[0].date.to_s.should eq "#{year}-05-30T11:07:00+00:00"
          subject[0].description.should eq "NOTICE LEFT"
          subject[0].location.should eq "WILMINGTON, DE 19801"
          subject[1].date.to_s.should eq "#{year}-05-30T10:08:00+00:00"
          subject[1].description.should eq "ARRIVAL AT UNIT"
          subject[1].location.should eq "WILMINGTON, DE 19850"
          subject[2].date.to_s.should eq "#{year}-05-29T09:55:00+00:00"
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
