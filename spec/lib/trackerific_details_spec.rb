require 'spec_helper'

describe Trackerific::Details do
  before(:all) do
    @details = Trackerific::Details.new(String.new, String.new, Array.new)
  end
  
  describe "events" do
    specify { @details.events.should be_a Array }
  end
  
  describe "package_id" do
    specify { @details.package_id.should be_a String }
  end
  
  describe "summary" do
    specify { @details.summary.should be_a String }
  end
end
