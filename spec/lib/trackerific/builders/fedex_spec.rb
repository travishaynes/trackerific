require 'spec_helper'

describe Trackerific::Builders::FedEx do
  it { should be_a Trackerific::Builders::Base::SOAP }

  describe "#members" do
    subject { described_class.members }
    it { should include :key }
    it { should include :password }
    it { should include :account_number }
    it { should include :meter_number }
    it { should include :package_id }
  end

  describe "#new" do
    let(:params) do
      [ "KEY", "PASSWORD", "ACCOUNT NUMBER", "METER NUMBER", "PACKAGE ID" ]
    end

    let(:transaction_id) { "TRANSACTION ID" }
    let(:instance) { described_class.new(*params) }
    let(:hash) { instance.hash }

    before do
      described_class.any_instance.stub(:customer_transaction_id).and_return(transaction_id)
    end

    describe "WebAuthenticationDetail" do
      let(:web_authentication_detail) { hash[:WebAuthenticationDetail] }

      describe "UserCredential" do
        subject { web_authentication_detail[:UserCredential] }
        its([:Key]) { should eq "KEY" }
        its([:Password]) { should eq "PASSWORD" }
      end
    end

    describe "ClientDetails" do
      subject { hash[:ClientDetails] }
      its([:AccountNumber]) { should eq "ACCOUNT NUMBER" }
      its([:MeterNumber]) { should eq "METER NUMBER" }
    end

    describe "TransactionDetail" do
      subject { hash[:TransactionDetail] }
      its([:CustomerTransactionId]) { should eq transaction_id }
    end

    describe "Version" do
      subject { hash[:Version] }
      its([:ServiceId]) { should eq "trck" }
      its([:Major]) { should eq "7" }
      its([:Intermediate]) { should eq "0" }
      its([:Minor]) { should eq "0" }
    end

    describe "SelectionDetails" do
      let(:selection_details) { hash[:SelectionDetails] }
      subject { selection_details }
      its([:CarrierCode]) { should eq "FDXE" }

      describe "PackageIdentifier" do
        subject { selection_details[:PackageIdentifier] }
        its([:Type]) { should eq "TRACKING_NUMBER_OR_DOORTAG" }
        its([:Value]) { should eq "PACKAGE ID" }
      end
    end

    describe "ProcessingOptions" do
      subject { hash[:ProcessingOptions] }
      it { should eq "INCLUDE_DETAILED_SCANS" }
    end
  end
end
