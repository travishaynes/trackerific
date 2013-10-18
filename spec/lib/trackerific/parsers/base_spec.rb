require 'spec_helper'

describe Trackerific::Parsers::Base do
  let(:package_id) { "PACKAGE ID" }
  let(:response) { double(:response) }
  let(:parser) { described_class.new(package_id, response) }

  let(:response_error) { nil }
  let(:summary) { "SUMMARY" }
  let(:events) { double([Trackerific::Event]) }

  describe "#parse" do
    let(:stub_summary) { true }
    let(:stub_events) { true }
    let(:stub_response_error) { true }

    before do
      parser.stub(:summary).and_return(summary) if stub_summary
      parser.stub(:events).and_return(events) if stub_events
      parser.stub(:response_error).and_return(response_error) if stub_response_error
    end

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

    context "when the subclass does not properly define all required methods" do
      context "when #response_error is not overridden" do
        let(:stub_response_error) { false }
        it "should raise a NotImplementedError" do
          expect { subject }.to raise_error NotImplementedError
        end
      end

      context "when #events is not overridden" do
        let(:stub_events) { false }
        it "should raise a NotImplementedError" do
          expect { subject }.to raise_error NotImplementedError
        end
      end

      context "when #summary is not overridden" do
        let(:stub_summary) { false }
        it "should raise a NotImplementedError" do
          expect { subject }.to raise_error NotImplementedError
        end
      end
    end
  end

end
