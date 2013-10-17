require 'spec_helper'

describe Trackerific do
  describe "#env" do
    let(:rack_env) { nil }
    let(:rails_env) { nil }

    before(:all) do
      Trackerific.env = nil
    end

    before(:each) do
      ENV['RAILS_ENV'] = rails_env
      ENV['RACK_ENV'] = rack_env
    end

    after(:all) do
      Trackerific.env = 'test'
      ENV['RAILS_ENV'] = nil
      ENV['RACK_ENV'] = 'test'
    end

    subject { Trackerific.env }

    context "when RAILS_ENV and RACK_ENV are not present" do
      it { should eq 'development' }
    end

    context "when RAILS_ENV is present" do
      let(:rails_env) { 'RAILS' }
      it { should eq rails_env }
    end

    context "when RACK_ENV is present" do
      let(:rack_env) { 'RACK' }
      it { should eq rack_env }
    end

    context "when RAILS_ENV and RACK_ENV is present" do
      let(:rack_env) { 'RACK' }
      let(:rails_env) { 'RAILS' }
      it { should eq rails_env }
    end
  end
end
