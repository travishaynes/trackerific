require 'spec_helper'

class TestBaseClass < Trackerific::Base
  def required_options
    [:required, :also_required]
  end
end

describe 'Trackerific::Base' do
  
  before(:all) do
    @base = Trackerific::Base.new
  end

  describe "tracking_service" do
    include Trackerific
    context "when given a UPS tracking number" do
      specify { tracking_service("1Z12345E0291980793").should eq Trackerific::UPS }
    end
    context "when given a USPS tracking number" do
      specify { tracking_service("EJ958083578US").should eq Trackerific::USPS }
    end
    context "when given a FedEx tracking number" do
      specify { tracking_service("183689015000001").should eq Trackerific::FedEx }
    end
    context "when given an invalid tracking number" do
      specify { tracking_service("invalid tracking number").should be_nil }
    end
  end
  
  context "with a new Trackerific::Base class that has required options" do
    context "has all the required options" do
      it "should be able to create a new instance" do
        t = TestBaseClass.new(:required => true, :also_required => :yup)
        t.should be_a TestBaseClass
      end
    end
    context "is missing some required options" do
      it "should raise an ArgumentError" do
        lambda { TestBaseClass.new() }.should raise_error(ArgumentError)
      end
    end
    context "has an invalid option" do
      it "should raise an ArgumentError" do
        lambda { TestBaseClass.new(:unknown => :argument ) }.should raise_error(ArgumentError)
      end
    end
  end
  
end
