class HabtmRelation < ActiveRecord::Migration
    def self.up
        remove_column :relations, :natlib_metadata_id
        add_column :relations, :permalink, :string


         create_table :natlib_metadatas_relations, :id => false do |t|
           t.integer :relation_id
           t.integer :natlib_metadata_id
           t.timestamps
         end
    end

    def self.down
        drop_table :relations_natlib_metadatas_subjects;
        remove_column :relations, :permalink
        add_column :relations, :natlib_metadata_id, :integer
    end
end
