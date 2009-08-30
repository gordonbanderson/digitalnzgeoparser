class CreateIdentifiers < ActiveRecord::Migration
  def self.up
    create_table :identifiers do |t|
      t.string :name
      t.integer :natlib_metadata_id

      t.timestamps
    end
  end

  def self.down
    drop_table :identifiers
  end
end
