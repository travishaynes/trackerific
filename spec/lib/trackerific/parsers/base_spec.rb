require 'spec_helper'

describe Trackerific::Parsers::Base do
  let(:package_id) { "PACKAGE ID" }
  let(:response) { double(:response) }
  let(:parser) { described_class.new(package_id, response) }

  let(:summary) { "SUMMARY" }
  let(:events) { double([Trackerific::Event]) }

  before do
    parser.stub(:summary).and_return(summary)
    parser.stub(:events).and_return(events)
    parser.stub(:response_error).and_return(response_error)
  end

  describe "#parse" do
    subject { parser.parse }

    context "when #response_error is a Trackerific::Error" do
      let(:response_error) { Trackerific::Error.new }
      it { should eq response_error }
    end

    context "when #response_error is false" do
      let(:response_error) { false }
      it { should be_a Trackerific::Details }
      its(:package_id) { should eq package_id }
      its(:summary) { should eq summary }
      its(:events) { should eq events }
    end
  end
end
