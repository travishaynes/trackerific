require 'spec_helper'

describe Trackerific do
  it { should respond_to :config }
  it { should respond_to :configure }

  describe "#track" do
    it "should return an Array of Trackerific::Details" do
      results = Trackerific.track("TEST")
      results.should be_a Array
      results.count.should eq 2
      results.all? {|r| r.should be_a Trackerific::Details }
    end
  end
end
