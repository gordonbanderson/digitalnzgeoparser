class CountryName < ActiveRecord::Base
  belongs_to :country
  
  validates_uniqueness_of :name
end
