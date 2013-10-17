require 'spec_helper'

describe Trackerific::Builders::Base::SOAP do
  let(:builder) { described_class.new(:hello, :world) }

  context "when #build is not implemented in the subclass" do
    it "should raise a NotImplementedError on initialize" do
      expect {
        builder.new
      }.to raise_error NotImplementedError
    end
  end

  context "when #build is implemented in the subclass" do
    before do
      builder.any_instance.stub(:build).and_return("BUILD")
    end

    it "should call #build on initialize" do
      builder.any_instance.should_receive(:build)
      builder.new
    end

    it "should assign the output of #build to #hash" do
      b = builder.new
      b.hash.should eq "BUILD"
    end
  end
end
