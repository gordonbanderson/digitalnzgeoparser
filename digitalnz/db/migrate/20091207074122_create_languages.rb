class CreateLanguages < ActiveRecord::Migration
  def self.up
    create_table :languages do |t|
        t.string :name
        t.string :permalink
        t.timestamps
    end
    
    puts "**** WARNING - ANY EXISTING CREATOR DATA WILL BE LOST ****"
    remove_column :natlib_metadatas, :language


    #Has and belongs to many join between calais entries and submissions
      create_table :languages_natlib_metadatas, :id => false do |t|
        t.integer :language_id
        t.integer :natlib_metadata_id
        t.timestamps
      end
  end

  def self.down
    drop_table :languages
    drop_table :languages_natlib_metadatas
    add_column :natlib_metadatas, :language, :string
  end
end

