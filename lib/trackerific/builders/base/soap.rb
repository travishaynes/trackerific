# Base class for SOAP request builders
# @api public
class Trackerific::Builders::Base::SOAP < Struct
  attr_reader :hash

  def initialize(*args)
    super(*args)
    @hash = build
  end

  protected

  # Implement this method in your builder
  # @api public
  def build
    raise NotImplementedError,
      "Implement this method in your builder subclass", caller
  end
end
