class LocationTypesRestriction < ActiveRecord::Base

  belongs_to :location_type, optional: true
  belongs_to :parentage_restriction, optional: true

end