class CheckPrecisionGeo < ActiveRecord::Migration
  def self.up
      #Taken from http://earthcode.com/blog/2006/12/latitude_and_longitude_columns.html
 #     add_column :cached_geo_searches, :x, :decimal, :precision => 15, :scale => 10
 #     add_column :cached_geo_searches, :y, :decimal,  :precision => 15, :scale => 10
      #add_column :formats, :natlib_metadata_id, :integer
      
  end

  def self.down
 #     remove_column :cached_geo_searches, :x
 #     remove_column :cached_geo_searches, :y
  end
end
