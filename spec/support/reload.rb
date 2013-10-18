module Trackerific
  def self.reload!(path)
    path = File.join("..", "..", "..", "lib", path)
    load File.expand_path(path, __FILE__)
  end
end
