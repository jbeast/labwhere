##
# A location can store locations or labware
class Location < ActiveRecord::Base

  include Searchable::Client
  include HasActive
  include AddAudit

  belongs_to :location_type, counter_cache: true
  belongs_to :parent, class_name: "Location"
  has_many :children, class_name: "Location", foreign_key: "parent_id"
  has_many :audits, as: :auditable
  has_many :labwares

  validates :name, presence: true
  validates :location_type, existence: true, unless: Proc.new { |l| l.unknown? }
  validates_format_of :name, with: /\A[\w\-\s]+\z/
  validates_length_of :name, maximum: 50

  scope :without, ->(location) { active.where.not(id: location.id) }
  scope :without_unknown, ->{ where.not(id: Location.unknown.id) }

  after_create :generate_barcode

  searchable_by :name, :barcode

  def parent
    super || NullLocation.new
  end

  def self.unknown
    find_by(name: "UNKNOWN") || create(name: "UNKNOWN")
  end

  def self.names(locations, spacer = " ")
    locations.map(&:name).join(spacer)
  end

  def self.find_by_code(code)
    find_by(barcode: code)
  end

  def self.reset_labwares_count(locations)
    locations.each do |location|
      location.update_column(:labwares_count, location.labwares.count)
    end
  end

  def unknown?
    name == "UNKNOWN" 
  end

  class NullLocation
    def name; "Empty" end

    def barcode; "Empty" end

    def parent; nil end

    def valid?; false end

    def empty?; true end
    
  end

private

  def generate_barcode
    update_column(:barcode, "#{self.name.gsub(' ','-')}-#{self.id}")
  end

end
