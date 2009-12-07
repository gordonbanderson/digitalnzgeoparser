class HabtmIdentifiers < ActiveRecord::Migration
  def self.up
      remove_column :identifiers, :natlib_metadata_id
      add_column :identifiers, :permalink, :string


       create_table :identifiers_natlib_metadatas, :id => false do |t|
         t.integer :identifier_id
         t.integer :natlib_metadata_id
         t.timestamps
       end
  end

  def self.down
      drop_table :identifiers_natlib_metadatas_subjects;
      remove_column :identifiers, :permalink
      add_column :identifiers, :natlib_metadata_id, :integer
  end
end
