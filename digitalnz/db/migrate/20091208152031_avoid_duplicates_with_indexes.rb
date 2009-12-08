class AvoidDuplicatesWithIndexes < ActiveRecord::Migration
  def self.up
      add_index :subjects, :name, :unique => true

=begin
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
=end
  end

  def self.down
  end
end
