require 'spec_helper'

describe Trackerific::Event do
  let(:date) { Time.now }
  let(:description) { "DESCRIPTION" }
  let(:location) { "LOCATION" }

  subject { described_class.new(date, description, location) }

  its(:date) { should eq date }
  its(:description) { should eq description }
  its(:location) { should eq location }


  let(:to_s_regex) do
    /(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) (0[1-9]|[1-2][0-9]|3[01]) \d{2}:\d{2} (am|pm).*/
  end
  its(:to_s) { should =~ to_s_regex }
end
