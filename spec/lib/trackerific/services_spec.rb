require 'spec_helper'

describe Trackerific::Services do
  describe "#[]=" do
    context "with a Trackerific::Services::Base" do
      it "should add service" do
        Trackerific::Services[:test] = TestService
        Trackerific::Services[:test].should eq TestService
      end
    end

    context "with a class other than Trackerific::Services::Base" do
      it "should raise an ArgumentError" do
        expect {
          Trackerific::Services[:string] = String
        }.to raise_error ArgumentError
      end
    end
  end

  describe "#[]" do
    it "should find registered services" do
      Trackerific::Services[:another_test_service].should eq AnotherTestService
    end

    it "should return nil for unknown services" do
      Trackerific::Services[:not_found].should be_nil
    end
  end

  describe "#find_by_package_id" do
    let(:id) { "TEST" }
    subject { Trackerific::Services.find_by_package_id(id) }
    it { should include TestService }
    it { should include AnotherTestService }

    context "with a service that has no credentials" do
      before { Trackerific.config.test = nil }
      after { Trackerific.config.test = { user: 'test' } }
      it { should_not include TestService }
      it { should include AnotherTestService }
    end
  end
end
