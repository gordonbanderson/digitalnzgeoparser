class HabtmCategories < ActiveRecord::Migration
  def self.up
      remove_column :categories, :natlib_metadata_id
      
      create_table :categories_natlib_metadatas, :id => false do |t|
        t.integer :category_id
        t.integer :natlib_metadata_id
        t.timestamps
      end
  end

  def self.down
      drop_table :categories_natlib_metadatas
      add_column :categories, :natlib_metadata_id, :integer
  end
end
