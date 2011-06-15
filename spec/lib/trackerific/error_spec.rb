require 'spec_helper'

describe Trackerific::Error do
  
  before { @error = Trackerific::Error.new }
  subject { @error }
  specify { should be_a StandardError }
  
end
