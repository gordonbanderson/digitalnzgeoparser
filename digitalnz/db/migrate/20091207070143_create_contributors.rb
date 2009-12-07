class CreateContributors < ActiveRecord::Migration
  def self.up
    create_table :contributors do |t|
        t.string :name
        t.string :permalink
        t.timestamps
    end
    
    puts "**** WARNING - ANY EXISTING CREATOR DATA WILL BE LOST ****"
    remove_column :natlib_metadatas, :contributor


    #Has and belongs to many join between calais entries and submissions
      create_table :contributors_natlib_metadatas, :id => false do |t|
        t.integer :contributor_id
        t.integer :natlib_metadata_id
        t.timestamps
      end
  end

  def self.down
    drop_table :contributors
    drop_table :contributors_natlib_metadatas
    add_column :natlib_metadatas, :contributor, :string
  end
end

