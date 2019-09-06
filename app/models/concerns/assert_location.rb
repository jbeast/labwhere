##
# Include on classes which have belong to location.
# It will ensure that location is never nil
module AssertLocation

  extend ActiveSupport::Concern

  included do
    before_validation :assert_location
  end

  ##
  # If the location is nil add the unknown location.
  def assert_location
    self.location = UnknownLocation.get if location.nil?
  end
end