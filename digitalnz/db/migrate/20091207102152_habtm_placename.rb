class HabtmPlacename < ActiveRecord::Migration
    def self.up


         create_table :natlib_metadatas_placenames, :id => false do |t|
           t.integer :placename_id
           t.integer :natlib_metadata_id
           t.timestamps
         end
    end

    def self.down
        drop_table :placenames_natlib_metadatas_subjects;
    end
end
