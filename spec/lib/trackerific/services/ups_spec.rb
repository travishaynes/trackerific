require 'spec_helper'

UPS_TRACK_URL = 'https://wwwcie.ups.com/ups.app/xml/Track'

describe Trackerific::Services::UPS do
  it { should be_a Trackerific::Services::Base }

  describe "#base_uri" do
    subject { described_class.base_uri }

    before do
      Trackerific.stub(:env).and_return(env)
      Trackerific.reload!('trackerific/services/ups.rb')
    end

    after(:all) { Trackerific.reload!('trackerific/services/ups.rb') }

    context "when Trackerific.env is 'production'" do
      let(:env) { 'production' }
      it { should eq "https://www.ups.com/ups.app/xml" }
    end

    context "when Trackerific.env is not 'production'" do
      let(:env) { 'development' }
      it { should eq 'https://wwwcie.ups.com/ups.app/xml' }
    end
  end

  let(:valid_ids) { ["1Z12345E0291980793"] }
  let(:invalid_ids) { %w[these are not valid tracking ids] }

  it "should match valid tracking ids" do
    valid_ids.all? {|id| described_class.can_track?(id) }.should be_true
  end

  it "should not match invalid tracking ids" do
    invalid_ids.all? {|id| described_class.can_track?(id) }.should be_false
  end

  describe "#track" do
    let(:id) { "1Z12345E0291980793" }
    let(:credentials) { { key: 'testkey', user_id: 'testuser', password: 'secret' } }
    let(:ups) { described_class.new(credentials) }

    before do
      FakeWeb.register_uri(:post, UPS_TRACK_URL, body: fixture)
    end

    after { FakeWeb.clean_registry }

    context "with a successful response" do
      let(:fixture) { Fixture.read('ups/success.xml') }
      subject { ups.track(id) }
      it { should be_a Trackerific::Details }
      its(:package_id) { should eq id }
      its(:summary) { should eq "DELIVERED" }
      its(:weight) { should be_nil }
      its(:via) { should be_nil }

      describe "#events" do
        subject { ups.track(id).events }
        its(:length) { should eq 1 }
        it "should populate the properties from the XML" do
          subject[0].date.should be_a DateTime
          subject[0].description.should eq "DELIVERED"
          subject[0].location.should eq "MAYSVILLE 26833   9700 US"
        end
      end
    end

    context "with an error response" do
      let(:fixture) { Fixture.read('ups/error.xml') }
      it "should raise a Trackerific::Error" do
        expect {
          ups.track(id)
        }.to raise_error Trackerific::Error
      end
    end
  end
end
