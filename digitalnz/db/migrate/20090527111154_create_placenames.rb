class CreatePlacenames < ActiveRecord::Migration
  def self.up
    create_table :placenames do |t|
      t.string :name
      t.integer :natlib_metadata_id

      t.timestamps
    end
  end

  def self.down
    drop_table :placenames
  end
end
