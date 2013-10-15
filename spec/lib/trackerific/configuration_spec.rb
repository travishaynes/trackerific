require 'spec_helper'

describe Trackerific::Configuration do
  before do
    Trackerific::Configuration.configure do |config|
      config.hello = 'world'
    end
  end

  subject { described_class.config }

  its(:hello) { should eq 'world' }
end
