module Trackerific
  module Builders
    class FedEx < Base::SOAP.new(:key, :password, :account_number, :meter_number, :package_id)
      protected

      def build
        { :WebAuthenticationDetail => web_authentication_detail,
          :ClientDetails => client_details,
          :TransactionDetail => transaction_detail,
          :Version => version,
          :SelectionDetails => selection_details,
          :ProcessingOptions => processing_options }
      end

      private

      def customer_transaction_id
        @customer_transaction_id ||= SecureRandom.hex(8)
      end

      def web_authentication_detail
        { :UserCredential => { :Key => key, :Password => password } }
      end

      def client_details
        { :AccountNumber => account_number,
          :MeterNumber => meter_number }
      end

      def transaction_detail
        { :CustomerTransactionId => customer_transaction_id }
      end

      def version
        { :ServiceId => 'trck',
          :Major => '7',
          :Intermediate => '0',
          :Minor => '0' }
      end

      def selection_details
        { :CarrierCode => 'FDXE',
          :PackageIdentifier => package_identifier }
      end

      def package_identifier
        { :Type => 'TRACKING_NUMBER_OR_DOORTAG',
          :Value => package_id }
      end

      def processing_options
        'INCLUDE_DETAILED_SCANS'
      end
    end
  end
end
