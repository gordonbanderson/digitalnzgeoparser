require 'text'
class GeoMetaphone < ActiveRecord::Migration
  def self.up
      puts "GEOMIG"
      add_column :cached_geo_searches, :metaphone1, :string
      add_column :cached_geo_searches, :metaphone2, :string
      #add_index :cached_geo_searches, :metaphone1
      #add_index :cached_geo_searches, :metaphone2
      
      max = CachedGeoSearch.count
      ctr = 0
      for cgs in CachedGeoSearch.find(:all, :conditions => ["metaphone1 is null"])
          ctr = ctr + 1
         le_words = cgs.address
         metaphones = Text::Metaphone.double_metaphone(le_words)
         cgs.metaphone1 = metaphones[0]
         cgs.metaphone2 = metaphones[1]
         cgs.save
         puts "#{ctr}/#{max}" if (ctr % 100) == 0
      end
  end

  def self.down
      puts "ROLLER"

      remove_index :cached_geo_searches, :metaphone1
      remove_index :cached_geo_searches, :metaphone2
      remove_column :cached_geo_searches, :metaphone1
      remove_column :cached_geo_searches, :metaphone2

  end
end
