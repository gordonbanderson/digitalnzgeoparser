class SubjectsHabtm < ActiveRecord::Migration
  def self.up
      puts "**** WILL RESULT IN LOSS OF DATA ****"
      remove_column :subjects, :natlib_metadata_id
      
      
      create_table :natlib_metadatas_subjects, :id => false do |t|
        t.integer :subject_id
        t.integer :natlib_metadata_id
        t.timestamps
      end
  end

  def self.down
      add_column :subjects, :natlib_metadata_id, :integer
      drop_table :natlib_metadatas_subjects
  end
end
