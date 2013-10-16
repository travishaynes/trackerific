require 'spec_helper'

describe Trackerific::Builders::UPS do
  it { should be_a Trackerific::Builders::XmlBuilder }

  subject { described_class.new("KEY", "USER ID", "PASSWORD", "PACKAGE ID") }

  let(:fixture) { Fixture.read('ups/request.xml') }

  its(:xml) { should eq fixture.strip }
end
