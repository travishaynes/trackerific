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

    describe "Web Authentication Detail" do
      let(:web_authentication_detail) { hash[:web_authentication_detail] }

      describe "User Credential" do
        subject { web_authentication_detail[:user_credential] }
        its([:key]) { should eq "KEY" }
        its([:password]) { should eq "PASSWORD" }
      end
    end

    describe "Client Detail" do
      subject { hash[:client_detail] }
      its([:account_number]) { should eq "ACCOUNT NUMBER" }
      its([:meter_number]) { should eq "METER NUMBER" }
    end

    describe "Transaction Detail" do
      subject { hash[:transaction_detail] }
      its([:customer_transaction_id]) { should eq "Trackerific" }
    end

    describe "Version" do
      subject { hash[:version] }
      its([:service_id]) { should eq "trck" }
      its([:major]) { should eq "12" }
      its([:intermediate]) { should eq "0" }
      its([:minor]) { should eq "0" }
    end

    describe "Selection Details" do
      let(:selection_details) { hash[:selection_details] }
      subject { selection_details }
      its([:carrier_code]) { should eq "FDXE" }

      describe "Package Identifier" do
        subject { selection_details[:package_identifier] }
        its([:type]) { should eq "TRACKING_NUMBER_OR_DOORTAG" }
        its([:value]) { should eq "PACKAGE ID" }
      end
    end

    describe "Processing Options" do
      subject { hash[:processing_options] }
      it { should eq "INCLUDE_DETAILED_SCANS" }
    end
  end
end
