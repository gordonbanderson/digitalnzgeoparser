class SpatialPointCachedGeoSearches < ActiveRecord::Migration
  def self.up
      #FIXME - switch to ISAM, separate table
      #Currently the spatial indexing does not work on mysql  on dreamhost :(
=begin
      add_column :cached_geo_searches, "geom", :point, :null=>false
      add_index :cached_geo_searches, "geom", :spatial=>true
      
      for cgs in CachedGeoSearch.find(:all)
          puts "SPATIAL SAVING:#{cgs.address} at #{cgs.latitude}, #{cgs.longitude}"
          
         cgs.geom =  Point.from_x_y(cgs.longitude, cgs.latitude)
         cgs.save
      end
=end
  end

  def self.down
=begin
      remove_column :cached_geo_searches, :geom
      remove_index :cached_geo_searches_points
=end
  end
end
