class Trackerific::Builders::FedEx < Trackerific::Builders::Base::SOAP.new(
  :key, :password, :account_number, :meter_number, :package_id)

  protected

  # Builds the FedEx track request XML
  # @api private
  def build
    root_nodes.inject({}) {|r, k| r[k] = send(k); r }
  end

  private

  # Array of XML root nodes
  # @api private
  def root_nodes
    [ :web_authentication_detail, :client_detail, :transaction_detail,
      :version, :selection_details, :processing_options ]
  end

  # Descriptive data to be used in authentication of the sender's identity
  # (and right to use FedEx web services)
  # @api private
  def web_authentication_detail
    { user_credential: { key: key, password: password } }
  end

  # Descriptive data identifying the client submitting the transaction
  # @api private
  def client_detail
    { account_number: account_number, meter_number: meter_number }
  end

  # Contains a free form field that is echoed back in the reply to match
  # requests with replies and data that governs the data payload
  # language/translations
  # @api private
  def transaction_detail
    { customer_transaction_id: "Trackerific" }
  end


  # The version of the FedEx API being used
  # @api private
  def version
    { service_id: 'trck', major: '8', intermediate: '0', minor: '0' }
  end

  # Specifies the details needed to select the shipment being requested to
  # be tracked
  # @api private
  def selection_details
    { carrier_code: 'FDXE', package_identifier: package_identifier }
  end

  # The type and value of the package identifier that is to be used to
  # retrieve the tracking information for a package or group of packages
  # @api private
  def package_identifier
    { type: 'TRACKING_NUMBER_OR_DOORTAG', value: package_id }
  end

  # Include detailed scan results
  # @api private
  def processing_options
    'INCLUDE_DETAILED_SCANS'
  end
end
