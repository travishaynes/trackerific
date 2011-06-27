require 'spec_helper'

describe Trackerific::Details do
  
  before do
    @required_details = {
      :package_id => String.new,
      :summary    => String.new,
      :events     => Array.new
    }
    @valid_options = {
      :weight     => Hash.new,
      :via        => String.new
    }
  end
  
  context "with required options only" do
    before { @details = Trackerific::Details.new(@required_details) }
    
    describe :events do
      subject { @details.events }
      it { should be_a Array }
    end
    
    describe :package_id do
      subject { @details.package_id }
      it { should be_a String }
    end
    
    describe :summary do
      subject { @details.summary }
      it { should be_a String }
    end
    
    describe :weight do
      subject { @details.weight }
      it { should be_nil }
    end
    
    describe :via do
      subject { @details.via }
      it { should be_nil }
    end
  end
  
  context "with all options" do
    before { @details = Trackerific::Details.new(@required_details.merge(@valid_options)) }
    
    describe :events do
      subject { @details.events }
      it { should be_a Array }
    end
    
    describe :package_id do
      subject { @details.package_id }
      it { should be_a String }
    end
    
    describe :summary do
      subject { @details.summary }
      it { should be_a String }
    end
    
    describe :weight do
      subject { @details.weight }
      it { should be_a Hash }
    end
    
    describe :via do
      subject { @details.via }
      it { should be_a String }
    end
  end
  
  context "with no options" do
    specify { lambda { Trackerific::Details.new }.should raise_error(ArgumentError) }
  end
  
  context "with invalid options" do
    specify { lambda { Trackerific::Details.new(:hello => "world")}.should raise_error(ArgumentError) }
  end
end
