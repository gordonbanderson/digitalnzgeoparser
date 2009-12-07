class IndexesAndFkeys < ActiveRecord::Migration
  def self.up


      change_table :cached_geo_searches do |t|
      t.foreign_key :cached_geo_search_terms
      end

      change_table :cached_geo_searches do |t|
      t.foreign_key :accuracies
      end
      
      change_table :centroids do |t|
      t.foreign_key :submissions
      end
      
      
      change_table :country_names do |t|
      t.foreign_key :countries
      end

      change_table :coverages do |t|
      t.foreign_key :natlib_metadatas
      end

      change_table :extents do |t|
      t.foreign_key :submissions
      end
      
      change_table :filtered_phrases do |t|
      t.foreign_key :phrases
      end

      change_table :filtered_phrases do |t|
      t.foreign_key :filter_types
      end
      






      change_table :phrase_frequencies do |t|
      t.foreign_key :submissions
      end

      change_table :phrase_frequencies do |t|
      t.foreign_key :phrases
      end

      change_table :placenames do |t|
      t.foreign_key :natlib_metadatas
      end

      change_table :record_dates do |t|
      t.foreign_key :natlib_metadatas
      end

      change_table :rights do |t|
      t.foreign_key :natlib_metadatas
      end

      change_table :submissions do |t|
      t.foreign_key :extents
      end

      change_table :submissions do |t|
      t.foreign_key :centroids
      end

      change_table :submissions do |t|
      t.foreign_key :natlib_metadatas
      end


    change_table :calais_entries do |t|
    t.foreign_key :calais_words, :column => :calais_child_word_id
    end

    change_table :calais_entries do |t|
    t.foreign_key :calais_words, :column => :calais_parent_word_id
    end

    change_table :facet_fields do |t|
       t.foreign_key :facet_fields, :column => :parent_id
     end
     
     
     
     add_index :cached_geo_searches, :permalink, :unique => true
     add_index :calais_words, :permalink, :unique => true
     add_index :categories, :permalink, :unique => true
     add_index :collections, :permalink, :unique => true
     add_index :content_partners, :permalink, :unique => true
     add_index :contributors, :permalink, :unique => true
     add_index :coverages, :permalink, :unique => true
     add_index :creators, :permalink, :unique => true
     add_index :formats, :permalink, :unique => true
     add_index :identifiers, :permalink, :unique => true
     add_index :languages, :permalink, :unique => true
     add_index :phrases, :permalink, :unique => true
     add_index :placenames, :permalink, :unique => true
     add_index :publishers, :permalink, :unique => true
     add_index :relations, :permalink, :unique => true
     add_index :rights, :permalink, :unique => true
     add_index :subjects, :permalink, :unique => true
      
  end

  def self.down
  end
end
