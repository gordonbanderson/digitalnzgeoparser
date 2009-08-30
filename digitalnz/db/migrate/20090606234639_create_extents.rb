class CreateExtents < ActiveRecord::Migration
  def self.up
    create_table :extents do |t|
      t.float :south
      t.float :north
      t.float :west
      t.float :east
      t.integer :submission_id
      t.timestamps
    end
  end

  def self.down
    drop_table :extents
  end
end
