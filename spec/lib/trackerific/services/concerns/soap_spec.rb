require 'spec_helper'

describe Trackerific::Services::Concerns::SOAP do
  class TestConcernsSOAP
    include Trackerific::Services::Concerns::SOAP

    def initialize
      @credentials = { user_id: 'USER ID' }
    end
  end

  subject { TestConcernsSOAP }

  it { should respond_to :soap_track_operation }
  it { should respond_to :soap_track_operation= }
  it { should respond_to :soap_builder }
  it { should respond_to :soap_builder= }
  it { should respond_to :soap_parser }
  it { should respond_to :soap_parser= }
  it { should respond_to :soap_wsdl }
  it { should respond_to :soap_wsdl= }

  describe "#track" do
    let(:track_operation) { double(:track_operation) }
    let(:package_id) { "PACKAGE ID" }

    let(:builder) { double(:builder) }
    let(:builder_instance) { double(:builder_instance) }
    let(:builder_hash) { {'this' => 'hash'} }

    let(:parser) { double(:parser) }
    let(:parser_instance) { double(:parser_instance) }
    let(:parser_response) { double(:parser_response) }

    let(:wsdl) { 'fedex/TrackService_v8' }
    let(:wsdl_path) { Trackerific::SOAP::WSDL.path(wsdl) }
    let(:client) { double(:savon_client) }
    let(:soap_request) { double(:soap_request) }

    before do
      TestConcernsSOAP.stub(:soap_track_operation).and_return(track_operation)
      TestConcernsSOAP.stub(:soap_wsdl).and_return(wsdl)
      TestConcernsSOAP.stub(:soap_builder).and_return(builder)
      TestConcernsSOAP.stub(:soap_parser).and_return(parser)

      builder.stub(:members).and_return([:user_id, :package_id])
      builder.should_receive(:new).with("USER ID", package_id).and_return(builder_instance)
      builder_instance.stub(:hash).and_return(builder_hash)

      Savon.should_receive(:client).with(convert_request_keys_to: :camelcase, wsdl: wsdl_path).and_return(client)
      client.should_receive(:call).with(track_operation, message: builder_hash).and_return(soap_request)

      parser.should_receive(:new).with(package_id, soap_request).and_return(parser_instance)
      parser_instance.should_receive(:parse).and_return(parser_response)
    end

    subject { TestConcernsSOAP.new.track(package_id) }

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
