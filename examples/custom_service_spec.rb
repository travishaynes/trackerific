require 'spec_helper'

describe Trackerific::CustomService do
  specify("it should descend from Trackerific::Service") {
    Trackerific::CustomService.superclass.should be Trackerific::Service
  }
  describe :track_package do
    before do
      @valid_package_id = 'valid package id'
      @invalid_package_id = 'invalid package id'
      @service = Trackerific::CustomService.new :required => 'option'
    end
    context "with a successful response from the server" do
      before(:each) do
        @tracking = @service.track_package(@valid_package_id)
      end
      subject { @tracking }
      it("should return a Trackerific::Details") { should be_a Trackerific::Details }
      describe :summary do
        subject { @tracking.summary }
        it { should_not be_empty }
      end
    end
    context "with an error response from the server" do
      specify { lambda { @service.track_package(@invalid_package_id) }.should raise_error(Trackerific::Error) }
    end
  end
  describe :required_options do
    subject { Trackerific::CustomService.required_options }
    it { should include(:required) }
  end
  describe :valid_options do
    it "should include required_options" do
      valid = Trackerific::CustomService.valid_options
      Trackerific::CustomService.required_options.each do |opt|
        valid.should include opt
      end
    end
  end
  describe :package_id_matchers do
    subject { Trackerific::CustomService.package_id_matchers }
    it("should be an Array of Regexp") { should each { |m| m.should be_a Regexp } }
  end
end
