class CreateBoundingBoxTrees < ActiveRecord::Migration
  def self.up
    create_table :bounding_box_trees do |t|
      t.integer :parent_id
      t.integer :cached_geo_search_id

      t.timestamps
    end
    
    add_column :bounding_box_trees, :submission_id, :integer
    
    add_index :bounding_box_trees, :cached_geo_search_id
  end

  def self.down
    drop_table :bounding_box_trees
    remove_index :bounding_box_trees, :cached_geo_search_id
    
  end
end
