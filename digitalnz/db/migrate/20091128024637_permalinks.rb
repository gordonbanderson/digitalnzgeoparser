class Permalinks < ActiveRecord::Migration
  def self.up
      add_column :coverages, :permalink, :string
      add_column :cached_geo_searches, :permalink, :string
      add_column :categories, :permalink, :string
      add_column :placenames, :permalink, :string
      add_column :calais_words, :permalink, :string
      add_column :phrases, :permalink, :string
      add_column :rights, :permalink, :string
      add_column :subjects, :permalink, :string
      

  end

  def self.down
      remove_column :coverages, :permalink
      remove_column :cached_geo_searches, :permalink
      remove_column :categories, :permalink
      remove_column :placenames, :permalink
      remove_column :calais_words, :permalink
      remove_column :phrases, :permalink
      remove_column :rights, :permalink
      remove_column :subjects, :permalink      
  end
end
