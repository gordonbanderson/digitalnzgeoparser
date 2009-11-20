class Someindexes < ActiveRecord::Migration

  def self.up
    add_index :facet_fields, :name
    add_index :natlib_metadatas, :natlib_id
    add_index :calais_submissions, :signature
    add_index :stop_words, :word
    add_index :calais_words, :word
    add_index :countries, :abbreviation
    add_index :cached_geo_search_terms, :search_term
    add_index :accuracies, :google_id
    add_index :tipes, :name
    add_index :phrases, :words
    add_index :filter_types, :name
  end

  def self.down
    drop_index :facet_fields, :name
    drop_index :natlib_metadatas, :natlib_id
    drop_index :calais_submissions, :signature
    drop_index :stop_words, :word
    drop_index :calais_words, :word
    drop_index :countries, :abbreviation
    drop_index :cached_geo_search_terms, :search_term
    drop_index :accuracies, :google_id
    drop_index :tipes, :name
    drop_index :phrases, :words
    drop_index :filter_types, :name
  end
end
