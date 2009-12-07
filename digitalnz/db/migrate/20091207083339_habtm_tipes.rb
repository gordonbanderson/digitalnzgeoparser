class HabtmTipes < ActiveRecord::Migration
  def self.up
      puts "**** WARNING - ANY EXISTING CREATOR DATA WILL BE LOST ****"
      remove_column :natlib_metadatas, :tipe_id


      #Has and belongs to many join between calais entries and submissions
        create_table :natlib_metadatas_tipes, :id => false do |t|
          t.integer :tipe_id
          t.integer :natlib_metadata_id
          t.timestamps
        end
  end

  def self.down
      drop_table :natlib_metadatas_tipes
      add_column :natlib_metadatas, :tipe_id, :integer
  end
end
