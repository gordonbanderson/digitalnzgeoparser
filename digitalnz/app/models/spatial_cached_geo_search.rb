class SpatialCachedGeoSearch < ActiveRecord::Base
  belongs_to :cached_geo_search
  
  validates_presence_of :cached_geo_search
  validates_presence_of :coordinates, :message => "A location must be provided"
  validates_presence_of :bounding_box, :message => "A location must be provided"
  
  


  
end

=begin
Creating a polygon

p = Polygon.from_coordinates(
[[
[170,-44],
[172,-43],
[172,-44]
]]
)


  SpatialCachedGeoSearch.find_by_geom([[3,5.6],[19.98,5.9]])
  
   #<GeoRuby::SimpleFeatures::Point:0x1033c6a28 @y=-36.825817, @with_m=false, @x=174.796507, @with_z=false, @m=0.0, @srid=-1, @z=0.0>
   
   SpatialCachedGeoSearch.find_all_by_coordinates([[174,-37],[175,-36]])
   
   SpatialCachedGeoSearch.find_by_coordinates([[172,-37],[1756-36]])
   
   
   SpatialCachedGeoSearch.find_all_by_coordinates([[174,-37],[175,-36]]).map{|m|m.cached_geo_search.address}.sort.map{|x| puts x}
   Tennyson St, Auckland 0627, New Zealand
   Tennyson St, Auckland, 1041, New Zealand
   The Esplanade, Manukau, Auckland 2012, New Zealand
   Timaru Pl, Auckland, 1060, New Zealand
   Titirangi, Auckland, New Zealand
   Tongariro St, Auckland, 1024, New Zealand
   Torbay, Auckland, New Zealand
   W Coast Rd, Waitakere, Auckland, New Zealand
   W Coast Rd, Warkworth, Auckland, New Zealand
   Waiake Beach, New Zealand
   Waiake St, Auckland 0630, New Zealand
   Waitangi, Kaukapakapa, Auckland 0984, New Zealand
   Waitemata Harbour, Auckland 0626, New Zealand
   Waitemata Harbour, Auckland 0626, New Zealand
   Waitemata Harbour, New Zealand
   
   
   SpatialCachedGeoSearch.find_all_by_coordinates(s.bounding_box).map{|m|m.cached_geo_search.address}.sort.map{|x| puts x}


torbay.map{|t| puts t.cached_geo_search.address+"\t"+pt.euclidian_distance(t.coordinates).to_s} << get point distance in metres

Searching

=end
