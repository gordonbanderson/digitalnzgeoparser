class CreateCreators < ActiveRecord::Migration
  def self.up
    create_table :creators do |t|
        t.string :name
        t.string :permalink
        t.timestamps
    end
    
    puts "**** WARNING - ANY EXISTING CREATOR DATA WILL BE LOST ****"
    remove_column :natlib_metadatas, :creator


    #Has and belongs to many join between calais entries and submissions
      create_table :creators_natlib_metadatas, :id => false do |t|
        t.integer :creator_id
        t.integer :natlib_metadata_id
        t.timestamps
      end
  end

  def self.down
    drop_table :creators
    drop_table :creators_natlib_metadatas
    add_column :natlib_metadatas, :creator, :string
  end
end
