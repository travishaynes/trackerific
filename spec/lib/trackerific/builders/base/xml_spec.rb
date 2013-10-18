require 'spec_helper'

describe Trackerific::Builders::Base::XML do
  let(:builder) { described_class.new(:hello, :world) }

  subject { builder }

  it { should respond_to :xml_version }
  it { should respond_to :xml_version= }

  context "when #build is not implemented in the subclass" do
    it "should raise a NotImplementedError on initialize" do
      expect {
        builder.new
      }.to raise_error NotImplementedError
    end
  end

  context "when #build is implemented in the subclass" do
    subject { builder.new('hi', 'earth') }

    before do
      builder.send(:define_method, :build) do
        builder.Hello hello
        builder.World world
      end
    end

    let(:xml) do
      '<?xml encoding="UTF-8"?><Hello>hi</Hello><World>earth</World>'
    end

    its(:xml) { should eq xml }
  end
end
