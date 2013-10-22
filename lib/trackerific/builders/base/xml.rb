class Trackerific::Builders::Base::XML < Struct
  class << self
    attr_accessor :xml_version
  end

  attr_reader :xml

  def initialize(*args)
    super(*args)
    @xml = ""
    build
  end

  protected

  def build
    raise NotImplementedError,
      "Implement this method in your builder subclass", caller
  end

  private

  def builder
    @builder ||= begin
      builder = Builder::XmlMarkup.new(target: @xml)
      add_xml_instruct(builder)
      builder
    end
  end

  def add_xml_instruct(builder)
    unless self.class.xml_version.nil?
      builder.instruct! :xml, version: self.class.xml_version
    end
  end
end
