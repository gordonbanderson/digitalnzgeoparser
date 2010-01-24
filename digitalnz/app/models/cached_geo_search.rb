require 'digest/sha2'

class CachedGeoSearch < ActiveRecord::Base
  has_and_belongs_to_many :cached_geo_search_terms
  belongs_to :accuracy
  
  acts_as_mappable :lat_column_name => :latitude,
                   :lng_column_name => :longitude,
                   :default_units => :kms
  
  has_and_belongs_to_many :submissions
  
  has_one :spatial_cached_geo_search
  
  
  #--- Spatial helpers for radius searching ---
  #Taken from http://www.frankodwyer.com/blog/?p=355 and amended
  # Calculate the bounding box for the circle of a given radius at a given point
  # and then return cachedgeosearches
  named_scope :radial_bounding_box_filter,
    #:select => "episodes.*",
    lambda { |point, radius| {
       :select => 'cached_geo_searches.id',
       :joins => "INNER JOIN spatial_cached_geo_searches s ON cached_geo_searches.id = s.cached_geo_search_id",
       :conditions=> "MBRContains(#{boundsLineString(point, radius)},coordinates)"
      }
    }

  
=begin
named_scope :visible, {
  :select => "episodes.*",
  :joins => "INNER JOIN series ON series.id = clips.owner_id INNER JOIN shows on shows.id = series.show_id", 
  :conditions=>"shows.visible = 1 AND clips.owner_type = 'Series' "
}
=end  
  named_scope :north_name,
              :conditions => ['address like ?','North%']
  
=begin
  named_scope :bounded,
  lambda { |latlng, radius|
  { :conditions=> "MBRContains(#{boundsLineString(latlng,radius)},geom)" }}
=end



  #Taken from http://www.frankodwyer.com/blog/?p=355
  #Note that latlng is (from geokit) latitude, longitude (ie y,x) where as georuby is x,y :(
  def self.boundsLineString(point,radius)
    puts "BOUNDS: Input is radius = #{radius}, lat long is #{point.to_yaml}"
    bounds=GeoKit::Bounds.from_point_and_radius([point.y, point.x],radius)
    result = "GeomFromText('LineString(#{bounds.sw.lng} #{bounds.sw.lat},#{bounds.ne.lng} #{bounds.ne.lat})')"
    puts "BOUND:#{result}"
    result
  end
  
  def is_significant_for_geocoding?
    accuracy.id < 6 #Using google constants
  end
  
  #Find other cached geo searches within a given radius (km)
  def find_all_within_km_radius(radius)
    puts "t1"
    point = spatial_cached_geo_search.coordinates
    puts "t2"
    puts point.to_yaml
    
    #The one stage method fails for reasons of messed up ids, so doing this in 
    #2 stages for now #FIXME
    
    #Filter the ids down by boudning box using spatial index
    ids = CachedGeoSearch.radial_bounding_box_filter(point, radius)
    
    #Filter out the remaining ones between the rectangle and the circle, and add a distance
    return CachedGeoSearch.find(
      :all,
      :conditions =>["id in (?)", ids.map{|c|c.id}],
      :origin=>[point.y, point.x],
      :within=>radius,
      :order=>'distance asc'
    )
    
   # .find(:all,
   #     :origin=>[point.y, point.x], :within=>radius, :order=>'distance asc')
  end
  
  
  def is_country?
    accuracy == Accuracy::COUNTRY
  end
 
=begin
<%= book.highlight("Jason", :field => :title, :num_excerpts => 1, :pre_tag => "<strong>", :post_tag => "</strong>") %>
<tr><td>Address</td><td><%=address%></td></tr>
<tr><td>Country</td><td><%=country%></td></tr>
<tr><td>Admin Area</td><td><%=admin_area%></td></tr>
<tr><td>Subadmin Area</td><%=subadmin_area%><td></td></tr>
<tr><td>Locality</td><td><%=locality%></td></tr>
<tr><td>Dependen Locality</td><td><%=dependent_locality%></td></tr>
<tr><td>Accuracy</td><td><%=accuracy.name%></td></tr>
=end 
  
  
  #Render a window for google maps
  def to_info_map_window(submission)
    template = ERB.new <<-EOF
  
    <table>
      <tr><td><%=submission.highlight(cached_geo_search_term.search_term, :field => :corpus, :num_of_excerpts => 10,
      :pre_tag => "<strong>", :post_tag => "</strong>"
      )%></td></tr>


	EOF
    result = template.result(binding)
	return "\n"+result.strip
  end
  
  #Save a dig sig of some of the parameters in an attempt to identify duplicates
  def update_signature
      sigstring = "#{address}:#{latitude}:#{longitude}:#{bbox_west}:#{bbox_east}:#{bbox_south}:#{bbox_north}"
      self.signature = Digest::SHA256.hexdigest(sigstring)
      puts "UPDATED SIG:#{signature}"
  end
  
  
  def before_save_NOT
    spatialize
  end
  
  #Update the spatial version of these coordinates prior to a save
  def spatialize
    s = spatial_cached_geo_search
    s = SpatialCachedGeoSearch::new if s.blank?
    s.cached_geo_search = self
    s.coordinates = Point.from_x_y(longitude, latitude)
    bbox_polygon = Polygon.from_coordinates(
    [[
    [bbox_west, bbox_south],
    [bbox_west, bbox_north],
    [bbox_east, bbox_north],
    [bbox_east, bbox_south],
    [bbox_west, bbox_south]
    ]]
    )
    s.bounding_box = bbox_polygon
    s.save
  end
  


  
end
