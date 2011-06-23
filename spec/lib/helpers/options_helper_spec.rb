require 'spec_helper'

describe OptionsHelper do
  include OptionsHelper
  
  describe :validate_options do
  
    context "with all required options" do
      before do
        @required = [:hello, :world]
        @options = {:hello => true, :world => true}
      end
      subject { validate_options(@options, @required) }
      it { should be true }
    end
    
    context "with missing required options" do
      before do
        @required = [:hello, :world]
        @options = {:hello => true}
      end
      specify { lambda { validate_options(@options, @required) }.should raise_error(ArgumentError) }
    end
    
    context "with no required options" do
      before do
        @required = []
        @options = {}
      end
      subject { validate_options(@options, @required) }
      it { should be true }
    end
    
    context "when required is nil" do
      before do
        @required = nil
        @options = {}
      end
      subject { validate_options(@options, @required) }
      it { should be true }
    end
    
    context "when options is nil" do
      before do
        @required = []
        @options = nil
      end
      subject { validate_options(@options, @required) }
      it { should be true }
    end
    
    context "when required and options are nil" do
      before do
        @required = nil
        @options = nil
      end
      subject { validate_options(@options, @required) }
      it { should be true }
    end
    
    context "with valid options" do
      before do
        @required = nil
        @options = {:valid => true}
        @valid = [:valid]
      end
      subject { validate_options(@options, @required, @valid) }
      it { should be true }
    end
    
    context "with invalid options" do
      before do
        @required = nil
        @options = {:invalid => true}
        @valid = [:valid]
      end
      subject { validate_options(@options, @required, @valid) }
      specify { lambda { validate_options(@options, @required) }.should raise_error(ArgumentError) }
    end
  end
  
end
