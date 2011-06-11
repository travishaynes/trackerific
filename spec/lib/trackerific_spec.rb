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
  
  describe :required_options do
    it "should return an Array" do
      @base.required_options().should be_kind_of Array
    end
  end
  
  describe :track_url do
    it "should return a String" do
      Trackerific::Base.track_url().should be_kind_of String
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
