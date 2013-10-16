require 'spec_helper'

describe Trackerific::Builders::XmlBuilder do
  class TestBuilder < Trackerific::Builders::XmlBuilder.new(:hello, :world)
    xml_version = "1.1"

    protected

    def build
      builder.Hello hello
      builder.World world
    end
  end

  let(:builder) { TestBuilder.new('hi', 'earth') }

  describe "#xml" do
    subject { builder.xml }
    let(:xml) do
      "<?xml encoding=\"UTF-8\"?><Hello>hi</Hello><World>earth</World>"
    end
    it { should eq xml }
  end
end
