module Trackerific::SOAP::WSDL
  ROOT = File.expand_path("../../../../vendor/wsdl", __FILE__)

  def self.path(name)
    path = File.join(ROOT, "#{name}.wsdl")

    unless File.exists?(path)
      raise IOError, "WSDL not found #{name}", caller
    end

    path
  end
end
