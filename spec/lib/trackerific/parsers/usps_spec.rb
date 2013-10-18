require 'spec_helper'

describe Trackerific::Parsers::USPS do
  let(:package_id) { "PACKAGE ID" }

  let(:xml) { "" }

  let(:response) { Hash.from_xml(xml) || {} }

  let(:parser) { described_class.new(package_id, response) }

  subject { parser }

  it { should be_a Trackerific::Parsers::Base }

  describe "#parse" do
    before do
      response.stub(:code).and_return(response_code)
    end

    subject { parser.parse }

    context "when response.code is not 200" do
      let(:response_code) { 404 }
      it { should be_a Trackerific::Error }
      its(:message) { should eq "HTTP returned status 404" }
    end

    context "when response.code is 200" do
      let(:response_code) { 200 }

      context "with an unknown/malformed response" do
        let(:xml) { Fixture.read('usps/malformed.xml') }
        it { should be_a Trackerific::Error }
      end

      context "with an error response" do
        let(:xml) { Fixture.read('usps/error.xml') }
        it { should be_a Trackerific::Error }
      end

      context "with a success response" do
        let(:xml) { Fixture.read('usps/success.xml') }
        it { should be_a Trackerific::Details }

        it "should populate its properties with values from the XML" do
          subject.package_id.should eq "PACKAGE ID"
          subject.summary.should eq "Your item was delivered at 8:10 am on June 1 in Wilmington DE 19801."
          subject.weight.should be_nil
          subject.via.should be_nil
        end

        describe "#events" do
          subject { parser.parse.events }

          it "should be an Array of Trackerific::Event" do
            subject.should be_a Array
            subject.length.should eq 3
            subject.all? {|e| e.should be_a Trackerific::Event }.should be_true
          end

          it "should populate the events with values from the XML" do
            subject[0].date.should be_a DateTime
            subject[0].description.should eq "NOTICE LEFT"
            subject[0].location.should eq "WILMINGTON, DE 19801"
            subject[1].date.should be_a DateTime
            subject[1].description.should eq "ARRIVAL AT UNIT"
            subject[1].location.should eq "WILMINGTON, DE 19850"
            subject[2].date.should be_a DateTime
            subject[2].description.should eq "ACCEPT OR PICKUP"
            subject[2].location.should eq "EDGEWATER, NJ 07020"
          end
        end
      end
    end
  end
end
