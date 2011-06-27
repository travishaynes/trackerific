require 'spec_helper'

describe "Trackerific.configuration" do
  include Trackerific
  
  subject { Trackerific.configuration }
  it { should be_a Trackerific::Configuration }
  
  context "with valid options" do
    it "should not raise any errors" do
      lambda {
        Trackerific.configure do |config|
          config.usps :user_id => 'userid'
        end
      }.should_not raise_error
    end
    it "should save a valid option" do
      Trackerific.configure do |config|
        config.usps :user_id => 'userid'
      end
      Trackerific.configuration.usps[:user_id].should eq 'userid'
    end
  end
  
  context "with invalid options" do
    it "should raise ArgumentError" do
      lambda {
        Trackerific.configure do |config|
          config.usps :invalid => 'option'
        end
      }.should raise_error ArgumentError
    end
  end
  
  context "with invalid configuration group - not a Trackerific:Service" do
    it "should raise NoMethodError" do
      lambda {
        Trackerific.configure do |config|
          config.qwertyuiop :invalid => 'group'
        end
      }.should raise_error(NoMethodError)
    end
  end
end
