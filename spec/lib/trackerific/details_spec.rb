require 'spec_helper'

describe Trackerific::Details do

  before { @details = Trackerific::Details.new(String.new, String.new, Array.new) }
  
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
  
end
