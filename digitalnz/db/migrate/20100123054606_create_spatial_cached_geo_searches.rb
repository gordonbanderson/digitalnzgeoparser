require 'geokit'

class CreateSpatialCachedGeoSearches < ActiveRecord::Migration
  def self.up

    create_table :spatial_cached_geo_searches, :options=>"ENGINE=MyISAM", :force => true do |t|
      
      t.integer :cached_geo_search_id
      t.column :coordinates, :point, :null=>false
      t.column :bounding_box, :polygon, :null => false

      t.timestamps
    end
    
    #Add spatial index for efficient querying
    add_index :spatial_cached_geo_searches, :coordinates, :spatial=>true
    add_index :spatial_cached_geo_searches, :bounding_box, :spatial=>true
    
    #Foreign key index
    add_index :spatial_cached_geo_searches, :cached_geo_search_id, :unique => true
    
    ctr = 0
    total = CachedGeoSearch.count
    puts "FIXING:#{total}"
    steps = 0
    while (steps*200 < total)
      for c in CachedGeoSearch.find(:all, :limit => 200, :offset => steps*200)
        ctr = ctr + 1
        puts "#{ctr}/#{total}..." if (ctr % 1000) == 0
        s = SpatialCachedGeoSearch::new
        s.cached_geo_search = c
        s.coordinates = Point.from_x_y(c.longitude, c.latitude)
        bbox_polygon = Polygon.from_coordinates(
        [[
        [c.bbox_west, c.bbox_south],
        [c.bbox_west, c.bbox_north],
        [c.bbox_east, c.bbox_north],
        [c.bbox_east, c.bbox_south],
        [c.bbox_west, c.bbox_south]
        ]]
        )
        s.bounding_box = bbox_polygon
        s.save!
      end
      steps = steps + 1
    end
    

    remove_column :cached_geo_searches, :geom
  end
  
  
  

  def self.down
    drop_index :spatial_cached_geo_searches, :geom
    drop_index :spatial_cached_geo_searches, :cached_geo_search_id
    drop_table :spatial_cached_geo_searches
    
    raise "Irreversible due to data loss"
  end
end
