require 'erb'
class CachedGeoSearchTerm < ActiveRecord::Base
  has_and_belongs_to_many :cached_geo_searches
  has_many :search_term_frequencies
  has_many :submissions, :through => :search_term_frequencies
  
  validates_uniqueness_of :search_term
  
  
  #If any of the searches are a country, the search term is marked similiarly
  def is_country?
    result = false
    for cgs in cached_geo_searches
      if cgs.is_country?
        result = true
        break
      end
    end
    result
  end
  
  

  
  

end
