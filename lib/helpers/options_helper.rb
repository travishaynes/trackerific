# Helper for validating required options
module OptionsHelper
  # Validates a list of options against a list of required options
  # @param [Array] options list of options to validate
  # @param [Array] required list of required options
  # @param [Array] valid list of additional valid options
  # @return true
  # @raise [ArgumentError] if the options do not pass validation
  # @api private
  def validate_options(options, required = [], valid = [])
    options = {} if options.nil?
    required = {} if required.nil?
    # make sure all the required options exist
    required.each do |k|
      raise ArgumentError.new("Missing required parameter: #{k}") unless options.has_key?(k)
    end
    # make sure no invalid options exist
    options.each do |k, v|
      raise ArgumentError.new("Invalid parameter: #{k}") unless required.include?(k) || valid.include?(k)
    end
    true
  end
end
