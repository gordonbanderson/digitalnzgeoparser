class CreateCachedGeoSearches < ActiveRecord::Migration
  def self.up
    create_table :cached_geo_searches do |t|
      t.float :latitude
      t.float :longitude
      t.boolean :search_term
      t.boolean :failed

      t.timestamps
    end
  end

  def self.down
    drop_table :cached_geo_searches
  end
end
