require 'spec_helper'

describe Trackerific::Event do
  
  before do
    @date = Time.now
    @description = "description"
    @location = "location"
    @event = Trackerific::Event.new(@date, @description, @location)
  end
  
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
