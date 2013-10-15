class Fixture
  def self.read(name)
    fixtures_path = File.expand_path("../../fixtures", __FILE__)
    File.read(File.join(fixtures_path, name))
  end
end
