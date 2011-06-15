# Provides easy access to XML fixtures
module Fixtures
  # Gets the path to the fixtures
  # @return [String]
  # @api private
  def fixture_path
    File.join(File.dirname(__FILE__), "..", "fixtures")
  end
  # Loads a fixture
  # @param [Symbol] name the fixture to load
  # @param [Symbol] ext the exention of the fixture. defaults to :xml
  # @example Load ups_success_response.xml
  #   response = load_fixture :ups_success_response
  # @return [String] the contents of the file
  # @api private
  def load_fixture(name, ext = :xml)
    file_name = File.join(fixture_path, "#{name.to_s}.#{ext.to_s}")
    File.read(file_name)
  end
end
