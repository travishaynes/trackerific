require 'spec_helper'

describe Trackerific::Parsers::UPS do
  let(:package_id) { "PACKAGE ID" }
  let(:response) { double(:response) }

  let(:parser) { described_class.new(package_id, response) }

  subject { parser }

  it { should be_a Trackerific::Parsers::Base }
end
