module Trackerific
  # Details returned when tracking a package. Stores the package identifier,
  # a summary, and the events, etc.
  class Details < Struct.new(:package_id, :summary, :events, :weight, :via)
  end
end
