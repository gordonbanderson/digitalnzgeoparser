class Accuracy < ActiveRecord::Base
  has_many :cached_geo_searches
  
  COUNTRY = Accuracy.find_by_google_id(1) #Google id for a country
end