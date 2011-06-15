require 'spec_helper'

describe "Trackerific.configuration" do
  include Trackerific
  
  subject { Trackerific.configuration }
  it { should be_a Trackerific::Configuration }
  
end
