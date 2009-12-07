class CreateCollections < ActiveRecord::Migration
  def self.up
    create_table :collections do |t|
        t.string :name
        t.string :permalink
        t.timestamps
    end
    
    puts "**** WARNING - ANY EXISTING CREATOR DATA WILL BE LOST ****"
    remove_column :natlib_metadatas, :collection


    #Has and belongs to many join between calais entries and submissions
      create_table :collections_natlib_metadatas, :id => false do |t|
        t.integer :collection_id
        t.integer :natlib_metadata_id
        t.timestamps
      end
  end

  def self.down
    drop_table :collections
    drop_table :collections_natlib_metadatas
    add_column :natlib_metadatas, :collection, :string
  end
end

