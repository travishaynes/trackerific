require 'spec_helper'

describe Trackerific::Builders::UPS do
  subject { described_class.new("KEY", "USER ID", "PASSWORD", "PACKAGE ID") }

  it { should be_a Trackerific::Builders::Base::XML }

  let(:fixture) { Fixture.read('ups/request.xml') }

  its(:xml) { should eq fixture.strip }
end
