class CreateCentroids < ActiveRecord::Migration
  def self.up
    create_table :centroids do |t|
      t.float :latitude
      t.float :longitude
      t.string :extent_type
      t.integer :submission_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :centroids
  end
end
