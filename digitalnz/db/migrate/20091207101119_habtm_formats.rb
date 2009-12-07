class HabtmFormats < ActiveRecord::Migration
    def self.up
        remove_column :formats, :natlib_metadata_id
        add_column :formats, :permalink, :string


         create_table :formats_natlib_metadatas, :id => false do |t|
           t.integer :format_id
           t.integer :natlib_metadata_id
           t.timestamps
         end
    end

    def self.down
        drop_table :formats_natlib_metadatas_subjects;
        remove_column :formats, :permalink
        add_column :formats, :natlib_metadata_id, :integer
    end
end
