class Geocachetweak < ActiveRecord::Migration
  def self.up
    create_table "cached_geo_search_terms", :force => true do |t| 
      t.string :search_term
      t.boolean :failed
      t.timestamps
    end
    
    #Drop columns not required, due to multiplicity of search
    remove_column :cached_geo_searches, :search_term
    remove_column :cached_geo_searches, :failed
    
    #Add the search term id
    add_column :cached_geo_searches, :cached_geo_search_term_id, :int

    #This is extra info available from the geocoder
    add_column :cached_geo_searches, :admin_area, :string
    add_column :cached_geo_searches, :subadmin_area, :string
    add_column :cached_geo_searches, :dependent_locality, :string
    add_column :cached_geo_searches, :locality, :string
    add_column :cached_geo_searches, :accuracy_id, :int
    add_column :cached_geo_searches, :country, :string
    add_column :cached_geo_searches, :address, :string    

    
  end

  def self.down
    drop_table :cached_geo_search_terms
    add_column :cached_geo_searches, :search_term, :string
    add_column :cached_geo_searches, :failed, :boolean
    
    remove_column :cached_geo_searches, :admin_area
    remove_column :cached_geo_searches, :cached_geo_search_term_id
    remove_column :cached_geo_searches, :subadmin_area
    remove_column :cached_geo_searches, :dependent_locality
    remove_column :cached_geo_searches, :locality
    remove_column :cached_geo_searches, :accuracy_id
    remove_column :cached_geo_searches, :country
    remove_column :cached_geo_searches, :address
  end
end
