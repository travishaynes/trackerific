require 'spec_helper'

describe Trackerific::Builders::USPS do
  it { should be_a Trackerific::Builders::Base::XML }

  subject { described_class.new("USER ID", "PACKAGE ID") }

  let(:fixture) { Fixture.read('usps/request.xml') }

  its(:xml) { should eq fixture.strip }
end
