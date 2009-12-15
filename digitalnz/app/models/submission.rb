require 'geo_parser_helper'

include GeoParserHelper

class Submission < ActiveRecord::Base
  has_and_belongs_to_many :cached_geo_searches, :include => [:cached_geo_search_term, :accuracy]
  has_and_belongs_to_many :filtered_phrases, :include => [:filter_type, :phrase]
  has_and_belongs_to_many :calais_entries
  
  
  has_one :extent, :dependent => :destroy
  has_one :centroid, :dependent => :destroy
  belongs_to :natlib_metadata
  has_many :phrases
  has_many :phrase_frequencies, :include => [:phrase], :dependent => :destroy
  
  
  #Return a decent description of the location found from the text submitted
  
  def geo_description
    result = body_of_text.clone
    result << "\n\n"
    
    result << "\nEXTENT"
    result << "\tSW: #{extent.south}, #{extent.west}"
    result << "\tNE: #{extent.north}, #{extent.east}"
    result << "\n\n"
    
    
    for cached_place in cached_geo_searches
      delta_from_centroid = distance_between_coordinates(centroid.latitude, 
                                                         centroid.longitude,
                                                         cached_place.latitude,
                                                         cached_place.longitude
      )
      place_string = "\t#{cached_place.cached_geo_search_term.search_term}\t#{cached_place.country} - #{cached_place.accuracy.name} - '#{cached_place.address} - #{cached_place.latitude}, #{cached_place.longitude} - ' D:#{delta_from_centroid}"
      result << place_string
      result << "\n"
      
      

      
      
    end
    result
  end
  
  #FIXME - use named scopes, and make more efficient
  def filtered_by(reason)
    result = []
    filter = FilterType.find_by_name(reason)
    for fp in filtered_phrases
      if fp.filter_type == filter
        result << fp
      end
    end
    result
  end
  
  
  def calculate_area
    x = cached_geo_searches
    if x.blank?
      area = nil
    else

      east = x[0].longitude
      west = x[0].longitude
      south = x[0].latitude
      north = x[0].latitude
      
      puts "There are #{x.length} locations to check"
  
      for location in x
        lat = location.latitude
        lon = location.longitude
        puts "CHECKING:#{location.cached_geo_search_term.search_term} #{lon}, #{lat}"
        east = lon if lon > east
        west = lon if lon < west
        north = lat if lat > north
        south = lat if lat < south
      end
      
      sw = CachedGeoSearch::new
      sw.latitude = south
      sw.longitude = west
      
      se = CachedGeoSearch::new
      se.latitude = south
      se.longitude = east
      
      ne = CachedGeoSearch::new
      ne.latitude = north
      ne.longitude = east
      
      eastdelta = sw.distance_to(se)
      northdelta = se.distance_to(ne)
      

      
      puts "W:#{west}"
      puts "E:#{east}"
      puts "S:#{south}"
      puts "N:#{north}"
      
      puts "ED:#{eastdelta}"
      puts "ND:#{northdelta}"
      self.area = eastdelta*northdelta
      puts "AREA:#{self.area} km2"
      save!
    end
  end
  
  

end
