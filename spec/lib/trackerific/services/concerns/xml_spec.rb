require 'spec_helper'

describe Trackerific::Services::Concerns::XML do
  subject { TestConcernsXML }

  describe "#track" do
    let(:endpoint) { "/endpoint" }
    let(:package_id) { "PACKAGE ID" }

    let(:parser) { double(:parser) }
    let(:parser_instance) { double(:parser_instance) }
    let(:parser_response) { double(:parser_response) }

    let(:builder) { double(:builder) }
    let(:builder_instance) { double(:builder_instance) }

    let(:http_response) { double(:http_response) }

    let(:xml) { "<xml></xml>" }

    before do
      TestConcernsXML.configure do |config|
        config.endpoint = endpoint
        config.parser = parser
        config.builder = builder
      end

      builder.stub(:members).and_return([:user_id, :package_id])
      builder.should_receive(:new).with('USER ID', package_id).and_return(builder_instance)
      builder_instance.stub(:xml).and_return(xml)

      TestConcernsXML.should_receive(:post).with(endpoint, body: xml).and_return(http_response)

      parser.should_receive(:new).with(package_id, http_response).and_return(parser_instance)
      parser_instance.should_receive(:parse).and_return(parser_response)
    end

    subject { TestConcernsXML.new.track(package_id) }

    context "when the parser responds with a Trackerific::Error" do
      let(:parser_response) { Trackerific::Error.new }
      it "should raise the error" do
        expect { subject }.to raise_error Trackerific::Error
      end
    end

    context "when the parser responds with a Trackerific::Details" do
      let(:parser_response) { Trackerific::Details.new }
      it { should be parser_response }
    end
  end
end
