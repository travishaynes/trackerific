require 'spec_helper'

describe Trackerific::Event do
  before(:all) do
    @date = Time.now
    @event = Trackerific::Event.new(Time.new, String.new, String.new)
  end
  
  describe "date" do
    specify { @event.date.should be_a Time }
  end
  
  describe "description" do
    specify { @event.description.should be_a String }
  end
  
  describe "location" do
    specify { @event.location.should be_a String }
  end
end
