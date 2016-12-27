require 'spec_helper'

describe Trackerific::SOAP::WSDL do
  describe "::ROOT" do
    subject { Trackerific::SOAP::WSDL::ROOT }

    it "should reference the vendor/wsdl path" do
      subject.should =~ /vendor\/wsdl/
      File.exists?(subject).should be_true
    end
  end

  describe "#path" do
    subject { described_class.path(filename) }

    context "with an invalid filename" do
      let(:filename) { 'invalid_file' }

      it "should raise a IOError" do
        expect { subject }.to raise_error IOError
      end
    end

    context "with a valid filename" do
      let(:filename) { 'fedex/TrackService_v12' }
      it { should =~ /#{Trackerific::SOAP::WSDL::ROOT}\/#{filename}\.wsdl/ }
    end
  end
end
