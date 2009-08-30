class CreateRelations < ActiveRecord::Migration
  def self.up
    create_table :relations do |t|
      t.string :name
      t.integer :natlib_metadata_id

      t.timestamps
    end
  end

  def self.down
    drop_table :relations
  end
end
