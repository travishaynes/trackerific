require 'spec_helper'

describe Trackerific::Services::Base do
  describe "#register" do
    it "should register the service" do
      # these classes were set up in support/test_services.rb
      Trackerific::Services[:test].should eq TestService
      Trackerific::Services[:another_test_service].should eq AnotherTestService
      TestService.name.should eq :test
      AnotherTestService.name.should eq :another_test_service
    end
  end

  describe "#configure" do
    it "should set @config properties passed from the given block" do
      TestService.configure {|c| c.value = 'this' }
      TestService.config.value.should eq 'this'
    end
  end

  describe "#config" do
    subject { TestService.new.config }
    it { should eq TestService.config }
  end

  describe "#track" do
    it "should create a new instance and call #track with the given id" do
      TestService.any_instance.should_receive(:track).with('ID')
      TestService.track('ID')
    end
  end

  describe "#credentials" do
    it "should read the credentials for the service from Trackerific.config" do
      TestService.credentials.should eq({ :user => 'test' })
    end
  end

  describe "#can_track?" do
    context "when #credentials is nil" do
      before { TestService.stub(:credentials).and_return(nil) }

      it "should return false even if it matches one of #package_id_matchers" do
        TestService.can_track?("TEST").should be_false
      end
    end

    context "when #credentials is defined" do
      before { Trackerific.stub(:credentials).and_return({:user => 'test'}) }

      subject { TestService.can_track?(id) }

      context "when the given id matches one of #package_id_matchers" do
        let(:id) { 'TEST' }
        it { should be_true }
      end

      context "when the given id doesn't match any of #package_id_matchers" do
        let(:id) { 'invalid' }
        it { should be_false }
      end
    end
  end

  describe "#package_id_matchers" do
    let(:matchers) { ['these','matchers'] }

    before do
      Trackerific::Services::Base.configure do |config|
        config.package_id_matchers = matchers
      end
    end

    subject { Trackerific::Services::Base.package_id_matchers }
    it { should eq matchers }
  end

  context "when creating a new instance without credentials" do
    before { TestService.stub(:credentials).and_return(nil) }
    it "should raise a Trackerific::Error" do
      expect {
        TestService.new
      }.to raise_error Trackerific::Error
    end
  end
end
