class CreateCoverages < ActiveRecord::Migration
  def self.up
      #FIXME - should be many many join
    create_table :coverages do |t|
      t.string :name
      t.integer :natlib_metadata_id

      t.timestamps
    end
  end

  def self.down
    drop_table :coverages
  end
end
