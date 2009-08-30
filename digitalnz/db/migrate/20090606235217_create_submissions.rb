class CreateSubmissions < ActiveRecord::Migration
  def self.up
    create_table :submissions do |t|
      t.text :body_of_text
      t.string :signature
      t.integer :extent_id
      t.integer :centroid_id
      t.integer :natlib_metadata_id
      t.timestamps
    end
  end

  def self.down
    drop_table :submissions
  end
end
