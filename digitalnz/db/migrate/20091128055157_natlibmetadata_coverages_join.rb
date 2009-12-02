class NatlibmetadataCoveragesJoin < ActiveRecord::Migration
    def self.up
        create_table :natlib_metadatas_coverages, :primary_key => false do |t|
              t.integer :coverage_id
              t.integer :natlib_metadata_id
        end
    end

    def self.down
         drop_table :natlib_metadatas_rights
    end
end
