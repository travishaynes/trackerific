require 'spec_helper'

describe Trackerific do
  describe "#configuration" do
    subject { Trackerific.configuration }
    it { should eq Trackerific::Configuration.config }
  end

  describe "#configure" do
    it "should delegate to Trackerific::Configuration.configure" do
      Trackerific.configure {|config| config.this = :value }
      Trackerific.configuration.this.should eq :value
    end
  end

  describe "#track" do
    it "should return an Array of Trackerific::Details" do
      results = Trackerific.track("TEST")
      results.should be_a Array
      results.count.should eq 2
      results.all? {|r| r.should be_a Trackerific::Details }
    end
  end
end
