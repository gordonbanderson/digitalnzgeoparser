class GoogleBoundingBoxes < ActiveRecord::Migration
  def self.up
    
      add_column :cached_geo_searches, :bbox_west, :float #, :null => false
      add_column :cached_geo_searches, :bbox_east, :float 
      add_column :cached_geo_searches, :bbox_north, :float
      add_column :cached_geo_searches, :bbox_south, :float
      
  end

  def self.down
      remove_column :cached_geo_searches, :bbox_west
      remove_column :cached_geo_searches, :bbox_east
      remove_column :cached_geo_searches, :bbox_north
      remove_column :cached_geo_searches, :bbox_south
  end
end
