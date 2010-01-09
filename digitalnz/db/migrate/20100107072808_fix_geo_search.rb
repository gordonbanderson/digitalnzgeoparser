class FixGeoSearch < ActiveRecord::Migration
  def self.up

      #Taken from http://earthcode.com/blog/2006/12/latitude_and_longitude_columns.html
      remove_column :cached_geo_searches, :latitude
      remove_column :cached_geo_searches, :longitude
      remove_foreign_key :cached_geo_searches, :cached_geo_search_term
      remove_column :cached_geo_searches, :cached_geo_search_term_id
      add_column :cached_geo_searches, :latitude, :decimal, :precision => 15, :scale => 10
      add_column :cached_geo_searches, :longitude, :decimal,  :precision => 15, :scale => 10

      create_table :cached_geo_search_terms_cached_geo_searches, :id => false do |t|
            t.integer :cached_geo_search_id
            t.integer :cached_geo_search_term_id
            t.foreign_key :cached_geo_searches
            t.foreign_key :cached_geo_search_terms
      end

        #MySQL has a limit on length of index key
        c = ActiveRecord::Base.connection()
           classname = c.class.to_s
        if classname == 'ActiveRecord::ConnectionAdapters::MysqlAdapter'

#ALTER TABLE `cached_geo_searches` DROP FOREIGN KEY `cached_geo_searches_cached_geo_search_term_id_fk`
            c.execute 'CREATE  INDEX `index_cgs_join21_id` ON `cached_geo_search_terms_cached_geo_searches` (`cached_geo_search_id`)'
            c.execute 'CREATE  INDEX `index_cgs_join22_id` ON `cached_geo_search_terms_cached_geo_searches` (`cached_geo_search_term_id`);'
        else
              add_index :cached_geo_search_terms_cached_geo_searches, :cached_geo_search_id
              add_index :cached_geo_search_terms_cached_geo_searches, :cached_geo_search_term_id
         end      

remove_column :cached_geo_searches, :bbox_west
add_column :cached_geo_searches, :bbox_west, :decimal, :precision => 15, :scale => 10
remove_column :cached_geo_searches, :bbox_south
add_column :cached_geo_searches, :bbox_south, :decimal, :precision => 15, :scale => 10
remove_column :cached_geo_searches, :bbox_north
add_column :cached_geo_searches, :bbox_north, :decimal, :precision => 15, :scale => 10
remove_column :cached_geo_searches, :bbox_east
add_column :cached_geo_searches, :bbox_east, :decimal, :precision => 15, :scale => 10
         
  end

  def self.down
      #raise "Irreversible"
  end
end
