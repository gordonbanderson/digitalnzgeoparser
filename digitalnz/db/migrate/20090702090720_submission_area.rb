class SubmissionArea < ActiveRecord::Migration
  def self.up
    add_column :submissions, :area, :float
  end

  def self.down
    remvoe_column :submissions, :area
  end
end
