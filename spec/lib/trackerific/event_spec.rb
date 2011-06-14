require 'spec_helper'

describe Trackerific::Event do
  before(:all) do
    @date = Time.now
    @description = "description"
    @location = "location"
    @event = Trackerific::Event.new(@date, @description, @location)
  end
  
  describe :date do
    specify { @event.date.should be_a Time }
  end
  
  describe :description do
    specify { @event.description.should be_a String }
  end
  
  describe :location do
    specify { @event.location.should be_a String }
  end
  
  describe :to_s do
    it "should be in format mmm dd hh:mm am/pm.*" do
      @event.to_s.should =~ /(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) (0[1-9]|[1-2][0-9]|3[01]) \d{2}:\d{2} (am|pm).*/
    end
  end
end
