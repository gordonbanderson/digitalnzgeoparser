class CachedGeoSearchesSubmissions < ActiveRecord::Migration
  def self.up
    create_table :cached_geo_searches_submissions, :id => false do |t|
      t.integer :submission_id
      t.integer :cached_geo_search_id
    end
    
  end

  def self.down
    drop_table :cached_geo_searches_submissions
  end
end
