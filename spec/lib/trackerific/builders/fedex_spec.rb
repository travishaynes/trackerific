require 'spec_helper'

describe Trackerific::Builders::FedEx do
  it { should be_a Trackerific::Builders::XmlBuilder }

  subject { described_class.new("ACCOUNT", "METER", "PACKAGE ID") }

  let(:fixture) { Fixture.read('fedex/request.xml') }

  its(:xml) { should eq fixture.strip }
end
