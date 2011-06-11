require 'spec_helper'

describe Trackerific::Base do
  
  it { should respond_to :track_package }
  it { should respond_to :required_options }
  
end
