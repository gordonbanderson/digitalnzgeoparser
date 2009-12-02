class NatlibmetadataRightsJoin < ActiveRecord::Migration
  def self.up
      create_table :natlib_metadatas_rights, :primary_key => false do |t|
            t.integer :right_id
            t.integer :natlib_metadata_id
          end
  end

  def self.down
       drop_table :natlib_metadatas_rights
  end
end
