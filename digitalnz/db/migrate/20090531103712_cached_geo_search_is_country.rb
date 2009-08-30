class CachedGeoSearchIsCountry < ActiveRecord::Migration
  def self.up
    add_column :cached_geo_search_terms, :is_country, :boolean
  end

  def self.down
    remove_column :cached_geo_search_terms, :is_country
    
  end
end
