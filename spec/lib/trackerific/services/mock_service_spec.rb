require 'spec_helper'
require 'trackerific/services/mock_service'

describe Trackerific::Services::MockService do
  it { should be_a Trackerific::Services::Base }

  it "should be registered" do
    Trackerific::Services[:mock_service].should eq described_class
  end

  describe "#package_id_matchers" do
    subject { described_class.package_id_matchers }
    it { should include /XXXXXXXXXX/ }
    it { should include /XXXxxxxxxx/ }
  end

  describe "#track" do
    let(:service) { described_class.new }

    context "with a valid id" do
      let(:id) { "XXXXXXXXXX" }
      subject { service.track(id) }
      it { should be_a Trackerific::Details }
      its(:package_id) { should eq id }
      its(:summary) { should eq "Your package was delivered." }
      its(:events) { should be_a Array }

      describe "#events" do
        subject { service.track(id).events }
        it { should be_a Array }
        its(:count) { should eq 3 }

        it "should have the proper event values" do
          subject[0].date.should be_a Date
          subject[0].description.should eq "Package delivered."
          subject[0].location.should eq "SANTA MARIA, CA"
          subject[1].date.should be_a Date
          subject[1].description.should eq "Package scanned."
          subject[1].location.should eq "SANTA BARBARA, CA"
          subject[2].date.should be_a Date
          subject[2].description.should eq "Package picked up for delivery."
          subject[2].location.should eq "LOS ANGELES, CA"
        end
      end
    end

    context "with an invalid id" do
      it "should raise a Trackerific::Error" do
        expect {
          service.track("XXXxxxxxxx")
        }.to raise_error Trackerific::Error
      end
    end
  end
end
