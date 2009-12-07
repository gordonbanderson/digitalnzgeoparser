class CreatePublishers < ActiveRecord::Migration
  def self.up
    create_table :publishers do |t|
        t.string :name
        t.string :permalink
        t.timestamps
    end
    
    puts "**** WARNING - ANY EXISTING CREATOR DATA WILL BE LOST ****"
    remove_column :natlib_metadatas, :publisher


    #Has and belongs to many join between calais entries and submissions
      create_table :natlib_metadatas_publishers, :id => false do |t|
        t.integer :publisher_id
        t.integer :natlib_metadata_id
        t.timestamps
      end
  end

  def self.down
    drop_table :publishers
    drop_table :natlib_metadatas_publishers
    add_column :natlib_metadatas, :publisher, :string
  end
end

