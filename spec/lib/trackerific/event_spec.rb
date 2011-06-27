require 'spec_helper'

describe Trackerific::Event do
  
  before do
    @date = Time.now
    @description = 'description'
    @location = 'location'
    @required_parameters = {
      :date         => @date,
      :description  => @description,
      :location     => @location
    }
  end
  
  context "with all required options" do
    before { @event = Trackerific::Event.new(@required_parameters) }
    
    describe :date do
      subject { @event.date }
      it { should be @date }
    end
    
    describe :description do
      subject { @event.description }
      it { should be @description }
    end
    
    describe :location do
      subject { @event.location }
      it { should be @location }
    end
    
    describe :to_s do
      before { @regex = /(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) (0[1-9]|[1-2][0-9]|3[01]) \d{2}:\d{2} (am|pm).*/ }
      subject { @event.to_s }
      it("should be in format mmm dd hh:mm am/pm.*") { should =~ @regex }
    end
  end
  
  context "missing some options" do
    specify { lambda { Trackerific::Event.new(:date => Time.now, :description => '') }.should raise_error(ArgumentError) }
  end
  
  context "with invalid options" do
    specify { lambda { Trackerific::Event.new(:hello => "world") }.should raise_error(ArgumentError) }
  end
end
