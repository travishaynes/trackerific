require 'spec_helper'

class TestServiceClass < Trackerific::Service
  class << self
    def required_options
      [:required, :also_required]
    end
  end
end

describe Trackerific::Service do
  
  describe :required_options do
    specify { Trackerific::Service.required_options.should be_kind_of Array }
  end
  
  describe :service_name do
    specify { Trackerific::Service.service_name.should be_kind_of String }
  end
  
  context "with a new Trackerific::Service class that has required options" do
    
    context "has all the required options" do
      it "should be able to create a new instance" do
        t = TestServiceClass.new(:required => true, :also_required => :yup)
        t.should be_a TestServiceClass
      end
    end
    
    context "is missing some required options" do
      it "should raise an ArgumentError" do
        lambda { TestServiceClass.new() }.should raise_error(ArgumentError)
      end
    end
    
    context "has an invalid option" do
      it "should raise an ArgumentError" do
        lambda { TestServiceClass.new(:unknown => :argument ) }.should raise_error(ArgumentError)
      end
    end
    
  end
  
end
