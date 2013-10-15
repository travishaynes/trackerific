require 'spec_helper'

describe Trackerific::Details do
  let(:id) { "PACKAGE ID" }
  let(:summary) { "SUMMARY" }
  let(:events) { ["THESE", "EVENTS"] }
  let(:weight) { "100lbs" }
  let(:via) { "USPS" }

  subject { described_class.new(id, summary, events, weight, via) }

  its(:package_id) { should eq id }
  its(:summary) { should eq summary }
  its(:events) { should eq events }
  its(:weight) { should eq weight }
  its(:via) { should eq via }
end
