##
# Scanning labware in and out of a location
# link between labware and locations and users.
class Scan < ActiveRecord::Base

  include AssertLocation

  enum status: [:in, :out]

  belongs_to :location
  belongs_to :user
  has_many :histories
  has_many :labwares, through: :histories

  before_save :update_labware_locations, :set_status

  ##
  # text message saying how much labware was scanned in and out of
  # a particular location.
  def message
    @message ||= "#{labwares.count} labwares scanned #{self.status} " << if in?
      "to #{location.name}"
    else
      "from #{Labware.previous_locations(labwares).map(&:name).join(" ")}"
    end
  end

  def create_message(labwares)
    self.message = "#{labwares.count} labwares scanned #{self.status} " << if in?
      "to #{location.name}"
    else
      "from #{Labware.previous_locations(labwares).map(&:name).join(" ")}"
    end
  end

private
  
  #TODO: abstract labware and location behaviour into appropriate place.
  def update_labware_locations
    labwares.each {|labware| labware.update(location: self.location)}
  end

  def set_status
    self.status = Scan.statuses[:out] if self.location.unknown?
  end

end
