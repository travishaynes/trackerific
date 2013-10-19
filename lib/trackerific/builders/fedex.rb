module Trackerific
  module Builders
    class FedEx < Base::SOAP.new(:key, :password, :account_number, :meter_number, :package_id)
      protected

      def build
        root_elements.inject({}) {|r, k| r[k] = send(k); r }
      end

      private

      def root_elements
        [ :web_authentication_detail, :client_detail, :transaction_detail,
          :version, :selection_details, :processing_options ]
      end

      def web_authentication_detail
        { user_credential: { key: key, password: password } }
      end

      def client_detail
        { account_number: account_number, meter_number: meter_number }
      end

      def transaction_detail
        { customer_transaction_id: "Trackerific" }
      end

      def version
        { service_id: 'trck', major: '8', intermediate: '0', minor: '0' }
      end

      def selection_details
        { carrier_code: 'FDXE', package_identifier: package_identifier }
      end

      def package_identifier
        { type: 'TRACKING_NUMBER_OR_DOORTAG', value: package_id }
      end

      def processing_options
        'INCLUDE_DETAILED_SCANS'
      end
    end
  end
end
